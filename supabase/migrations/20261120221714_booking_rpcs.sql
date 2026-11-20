-- ============================================================
-- Internal helpers (never callable by clients)
-- ============================================================

-- Slot grid for one pitch on one schedule date (Africa/Cairo local time).
-- If closing_time <= opening_time, the schedule runs past midnight.
create or replace function public._pitch_slots(p_pitch_id uuid, p_date date)
returns table (slot_start timestamptz, slot_end timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_open        time;
  v_close       time;
  v_dur         int;
  v_local_close timestamp;
  v_cur         timestamp;
begin
  select v.opening_time, v.closing_time, p.duration_minutes
    into v_open, v_close, v_dur
  from public.pitches p
  join public.venues v on v.id = p.venue_id
  where p.id = p_pitch_id;

  if v_open is null or v_close is null or v_dur is null then
    return;
  end if;

  v_cur := p_date + v_open;
  if v_close <= v_open then
    v_local_close := (p_date + 1) + v_close;
  else
    v_local_close := p_date + v_close;
  end if;

  while v_cur + make_interval(mins => v_dur) <= v_local_close loop
    slot_start := v_cur at time zone 'Africa/Cairo';
    slot_end   := (v_cur + make_interval(mins => v_dur)) at time zone 'Africa/Cairo';
    return next;
    v_cur := v_cur + make_interval(mins => v_dur);
  end loop;
end;
$$;

create or replace function public._notify(
  p_user_id uuid,
  p_type text,
  p_booking_id uuid,
  p_data jsonb
)
returns void
language sql
security definer
set search_path = public
as $$
  insert into public.notifications (user_id, type, booking_id, data)
  values (p_user_id, p_type, p_booking_id, coalesce(p_data, '{}'::jsonb));
$$;

-- ============================================================
-- get_available_slots(pitch_id, date)
-- ============================================================
create or replace function public.get_available_slots(p_pitch_id uuid, p_date date)
returns table (slot_start timestamptz, slot_end timestamptz, is_available boolean)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_pitch public.pitches%rowtype;
  v_today date := (now() at time zone 'Africa/Cairo')::date;
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;

  select * into v_pitch from public.pitches where id = p_pitch_id;
  if not found then
    raise exception 'not_found';
  end if;
  if not v_pitch.is_active then
    raise exception 'pitch_inactive';
  end if;
  if not public.venue_is_public(v_pitch.venue_id) then
    raise exception 'venue_inactive';
  end if;

  if p_date < v_today then
    raise exception 'in_the_past';
  end if;
  if p_date > v_today + 13 then
    raise exception 'too_far_ahead';
  end if;

  return query
  select
    s.slot_start,
    s.slot_end,
    (
      s.slot_start > now()
      and not exists (
        select 1
        from public.bookings b
        where b.pitch_id = p_pitch_id
          and b.status = 'confirmed'
          and tstzrange(b.start_time, b.end_time) && tstzrange(s.slot_start, s.slot_end)
      )
    ) as is_available
  from public._pitch_slots(p_pitch_id, p_date) s
  order by s.slot_start;
end;
$$;

-- ============================================================
-- create_booking(pitch_id, start_time) -> booking id
-- ============================================================
create or replace function public.create_booking(p_pitch_id uuid, p_start_time timestamptz)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid     uuid := auth.uid();
  v_today   date := (now() at time zone 'Africa/Cairo')::date;
  v_pitch   public.pitches%rowtype;
  v_venue   public.venues%rowtype;
  v_d0      date;
  v_sched   date;
  v_end     timestamptz;
  v_id      uuid;
  v_cust    text;
begin
  if v_uid is null then
    raise exception 'unauthenticated';
  end if;
  if public.current_role_name() is distinct from 'customer' then
    raise exception 'forbidden';
  end if;

  select * into v_pitch from public.pitches where id = p_pitch_id;
  if not found then
    raise exception 'not_found';
  end if;
  select * into v_venue from public.venues where id = v_pitch.venue_id;

  if not v_pitch.is_active then
    raise exception 'pitch_inactive';
  end if;
  if not public.venue_is_public(v_venue.id) then
    raise exception 'venue_inactive';
  end if;

  if exists (
    select 1 from public.venue_blocks
    where venue_id = v_venue.id and customer_id = v_uid
  ) then
    raise exception 'blocked';
  end if;

  if p_start_time <= now() then
    raise exception 'in_the_past';
  end if;

  -- The start must be exactly on the slot grid. After-midnight slots
  -- belong to the previous day's schedule, so check both dates.
  v_d0 := (p_start_time at time zone 'Africa/Cairo')::date;

  select s.slot_end into v_end
  from public._pitch_slots(p_pitch_id, v_d0) s
  where s.slot_start = p_start_time;

  if found then
    v_sched := v_d0;
  else
    select s.slot_end into v_end
    from public._pitch_slots(p_pitch_id, v_d0 - 1) s
    where s.slot_start = p_start_time;

    if found then
      v_sched := v_d0 - 1;
    else
      raise exception 'outside_hours';
    end if;
  end if;

  if v_sched < v_today then
    raise exception 'in_the_past';
  end if;
  if v_sched > v_today + 13 then
    raise exception 'too_far_ahead';
  end if;

  begin
    insert into public.bookings
      (customer_id, venue_id, pitch_id, start_time, end_time, price, status)
    values
      (v_uid, v_venue.id, p_pitch_id, p_start_time, v_end, v_pitch.price, 'confirmed')
    returning id into v_id;
  exception
    when exclusion_violation then
      raise exception 'slot_taken';
  end;

  select name into v_cust from public.profiles where id = v_uid;

  perform public._notify(
    v_venue.account_id, 'booking_created', v_id,
    jsonb_build_object(
      'pitch_name', v_pitch.name,
      'customer_name', v_cust,
      'start_time', p_start_time
    )
  );

  return v_id;
end;
$$;

-- ============================================================
-- cancel_booking(id): customer or venue, until start time.
-- A blocked customer can still cancel.
-- ============================================================
create or replace function public.cancel_booking(p_booking_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid   uuid := auth.uid();
  v_b     public.bookings%rowtype;
  v_by    text;
  v_venue public.venues%rowtype;
  v_pitch text;
begin
  if v_uid is null then
    raise exception 'unauthenticated';
  end if;

  select * into v_b from public.bookings where id = p_booking_id for update;
  if not found then
    raise exception 'not_found';
  end if;

  select * into v_venue from public.venues where id = v_b.venue_id;

  if v_b.customer_id = v_uid then
    v_by := 'customer';
  elsif v_venue.account_id = v_uid then
    v_by := 'venue';
  else
    raise exception 'not_found';
  end if;

  if v_b.status <> 'confirmed' then
    raise exception 'invalid_state';
  end if;
  if v_b.start_time <= now() then
    raise exception 'invalid_state';
  end if;

  update public.bookings
  set status = 'cancelled', cancelled_by = v_by, cancelled_at = now()
  where id = v_b.id;

  select name into v_pitch from public.pitches where id = v_b.pitch_id;

  if v_by = 'customer' then
    perform public._notify(
      v_venue.account_id, 'booking_cancelled_by_customer', v_b.id,
      jsonb_build_object(
        'pitch_name', v_pitch,
        'customer_name', (select name from public.profiles where id = v_b.customer_id),
        'start_time', v_b.start_time
      )
    );
  else
    perform public._notify(
      v_b.customer_id, 'booking_cancelled_by_venue', v_b.id,
      jsonb_build_object(
        'pitch_name', v_pitch,
        'venue_name', v_venue.name,
        'start_time', v_b.start_time
      )
    );
  end if;
end;
$$;

-- ============================================================
-- reconfirm_booking(id): customer only, from 24h before start
-- until start, once (idempotent).
-- ============================================================
create or replace function public.reconfirm_booking(p_booking_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid   uuid := auth.uid();
  v_b     public.bookings%rowtype;
  v_venue public.venues%rowtype;
begin
  if v_uid is null then
    raise exception 'unauthenticated';
  end if;

  select * into v_b from public.bookings where id = p_booking_id for update;
  if not found or v_b.customer_id <> v_uid then
    raise exception 'not_found';
  end if;

  if v_b.status <> 'confirmed' then
    raise exception 'invalid_state';
  end if;

  if v_b.reconfirmed_at is not null then
    return;
  end if;

  if now() < v_b.start_time - interval '24 hours' or now() >= v_b.start_time then
    raise exception 'reconfirm_unavailable';
  end if;

  update public.bookings set reconfirmed_at = now() where id = v_b.id;

  select * into v_venue from public.venues where id = v_b.venue_id;

  perform public._notify(
    v_venue.account_id, 'booking_reconfirmed', v_b.id,
    jsonb_build_object(
      'pitch_name', (select name from public.pitches where id = v_b.pitch_id),
      'customer_name', (select name from public.profiles where id = v_b.customer_id),
      'start_time', v_b.start_time
    )
  );
end;
$$;

-- ============================================================
-- mark_attendance(id, 'attended' | 'no_show'): venue only, after end_time
-- ============================================================
create or replace function public.mark_attendance(p_booking_id uuid, p_attendance text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_b   public.bookings%rowtype;
begin
  if v_uid is null then
    raise exception 'unauthenticated';
  end if;
  if p_attendance is null or p_attendance not in ('attended', 'no_show') then
    raise exception 'invalid_value';
  end if;

  select * into v_b from public.bookings where id = p_booking_id for update;
  if not found or v_b.venue_id is distinct from public.my_venue_id() then
    raise exception 'not_found';
  end if;

  if v_b.status <> 'confirmed' then
    raise exception 'invalid_state';
  end if;
  if now() < v_b.end_time then
    raise exception 'not_ended';
  end if;

  update public.bookings set attendance = p_attendance where id = v_b.id;
end;
$$;

-- ============================================================
-- Blocking (per venue)
-- ============================================================
create or replace function public.block_customer(p_customer_id uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue_id uuid := public.my_venue_id();
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;
  if v_venue_id is null then
    raise exception 'forbidden';
  end if;

  -- A customer can be blocked only if they have a booking at this venue.
  if not exists (
    select 1 from public.bookings
    where venue_id = v_venue_id and customer_id = p_customer_id
  ) then
    raise exception 'forbidden';
  end if;

  insert into public.venue_blocks (venue_id, customer_id, reason)
  values (v_venue_id, p_customer_id, nullif(trim(coalesce(p_reason, '')), ''))
  on conflict (venue_id, customer_id)
  do update set reason = excluded.reason;
end;
$$;

create or replace function public.unblock_customer(p_customer_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue_id uuid := public.my_venue_id();
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;
  if v_venue_id is null then
    raise exception 'forbidden';
  end if;

  delete from public.venue_blocks
  where venue_id = v_venue_id and customer_id = p_customer_id;
end;
$$;

-- Is the calling customer blocked at this venue? (reason is never exposed)
create or replace function public.is_blocked_at(p_venue_id uuid)
returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;

  return exists (
    select 1 from public.venue_blocks
    where venue_id = p_venue_id and customer_id = auth.uid()
  );
end;
$$;

-- ============================================================
-- Venue-side reads (customer name/phone exposed only here)
-- ============================================================
create or replace function public.get_venue_bookings(p_from timestamptz, p_to timestamptz)
returns table (
  id uuid,
  pitch_id uuid,
  pitch_name text,
  customer_id uuid,
  customer_name text,
  customer_phone text,
  start_time timestamptz,
  end_time timestamptz,
  price numeric,
  status text,
  cancelled_by text,
  cancelled_at timestamptz,
  reconfirmed_at timestamptz,
  attendance text,
  is_blocked boolean
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_venue_id uuid := public.my_venue_id();
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;
  if v_venue_id is null then
    raise exception 'forbidden';
  end if;

  return query
  select
    b.id,
    b.pitch_id,
    p.name,
    b.customer_id,
    c.name,
    c.phone,
    b.start_time,
    b.end_time,
    b.price,
    b.status,
    b.cancelled_by,
    b.cancelled_at,
    b.reconfirmed_at,
    b.attendance,
    exists (
      select 1 from public.venue_blocks vb
      where vb.venue_id = v_venue_id and vb.customer_id = b.customer_id
    )
  from public.bookings b
  join public.pitches p  on p.id = b.pitch_id
  join public.profiles c on c.id = b.customer_id
  where b.venue_id = v_venue_id
    and b.start_time >= p_from
    and b.start_time <  p_to
  order by b.start_time;
end;
$$;

create or replace function public.get_blocked_customers()
returns table (
  customer_id uuid,
  customer_name text,
  customer_phone text,
  reason text,
  blocked_at timestamptz
)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_venue_id uuid := public.my_venue_id();
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;
  if v_venue_id is null then
    raise exception 'forbidden';
  end if;

  return query
  select vb.customer_id, c.name, c.phone, vb.reason, vb.created_at
  from public.venue_blocks vb
  join public.profiles c on c.id = vb.customer_id
  where vb.venue_id = v_venue_id
  order by vb.created_at desc;
end;
$$;

-- ============================================================
-- complete_venue_setup(): idempotent
-- ============================================================
create or replace function public.complete_venue_setup()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_venue public.venues%rowtype;
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;

  select * into v_venue from public.venues
  where account_id = auth.uid() for update;
  if not found then
    raise exception 'forbidden';
  end if;

  if v_venue.setup_completed_at is not null then
    return;
  end if;

  if coalesce(trim(v_venue.name), '')    = ''
     or coalesce(trim(v_venue.phone), '')   = ''
     or coalesce(trim(v_venue.area), '')    = ''
     or coalesce(trim(v_venue.address), '') = ''
     or v_venue.latitude  is null
     or v_venue.longitude is null
     or v_venue.opening_time is null
     or v_venue.closing_time is null then
    raise exception 'venue_not_ready';
  end if;

  update public.venues set setup_completed_at = now() where id = v_venue.id;
end;
$$;

-- ============================================================
-- register_device_token(token, platform): upsert, reassigns on shared devices
-- ============================================================
create or replace function public.register_device_token(p_token text, p_platform text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'unauthenticated';
  end if;
  if coalesce(trim(p_token), '') = '' or coalesce(trim(p_platform), '') = '' then
    raise exception 'invalid_value';
  end if;

  insert into public.device_tokens (user_id, token, platform)
  values (auth.uid(), p_token, p_platform)
  on conflict (token)
  do update set user_id = excluded.user_id,
                platform = excluded.platform,
                updated_at = now();
end;
$$;

-- ============================================================
-- Privileges: no EXECUTE for anon/public; clients get only the RPCs.
-- ============================================================
revoke execute on function public._pitch_slots(uuid, date)              from public, anon, authenticated;
revoke execute on function public._notify(uuid, text, uuid, jsonb)      from public, anon, authenticated;

revoke execute on function public.get_available_slots(uuid, date)           from public, anon;
revoke execute on function public.create_booking(uuid, timestamptz)         from public, anon;
revoke execute on function public.cancel_booking(uuid)                      from public, anon;
revoke execute on function public.reconfirm_booking(uuid)                   from public, anon;
revoke execute on function public.mark_attendance(uuid, text)               from public, anon;
revoke execute on function public.block_customer(uuid, text)                from public, anon;
revoke execute on function public.unblock_customer(uuid)                    from public, anon;
revoke execute on function public.is_blocked_at(uuid)                       from public, anon;
revoke execute on function public.get_venue_bookings(timestamptz, timestamptz) from public, anon;
revoke execute on function public.get_blocked_customers()                   from public, anon;
revoke execute on function public.complete_venue_setup()                    from public, anon;
revoke execute on function public.register_device_token(text, text)        from public, anon;

grant execute on function public.get_available_slots(uuid, date)           to authenticated;
grant execute on function public.create_booking(uuid, timestamptz)         to authenticated;
grant execute on function public.cancel_booking(uuid)                      to authenticated;
grant execute on function public.reconfirm_booking(uuid)                   to authenticated;
grant execute on function public.mark_attendance(uuid, text)               to authenticated;
grant execute on function public.block_customer(uuid, text)                to authenticated;
grant execute on function public.unblock_customer(uuid)                    to authenticated;
grant execute on function public.is_blocked_at(uuid)                       to authenticated;
grant execute on function public.get_venue_bookings(timestamptz, timestamptz) to authenticated;
grant execute on function public.get_blocked_customers()                   to authenticated;
grant execute on function public.complete_venue_setup()                    to authenticated;
grant execute on function public.register_device_token(text, text)        to authenticated;