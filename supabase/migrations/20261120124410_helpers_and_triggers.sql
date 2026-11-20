-- ============================================================
-- Helper functions
-- ============================================================

-- Current role of the calling user.
create or replace function public.current_role_name()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;

-- Venue id owned by the calling venue account (null if none).
create or replace function public.my_venue_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.venues where account_id = auth.uid();
$$;

-- A venue is publicly visible only if active, setup complete,
-- and it has at least one active pitch.
create or replace function public.venue_is_public(p_venue_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.venues v
    where v.id = p_venue_id
      and v.is_active
      and v.setup_completed_at is not null
      and exists (
        select 1 from public.pitches p
        where p.venue_id = v.id and p.is_active
      )
  );
$$;

-- ============================================================
-- Signup trigger: create profile (+ venue row for venue accounts)
-- from auth.users raw_user_meta_data { role, name, phone }
-- ============================================================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_role  text := new.raw_user_meta_data ->> 'role';
  v_name  text := nullif(trim(coalesce(new.raw_user_meta_data ->> 'name', '')), '');
  v_phone text := nullif(trim(coalesce(new.raw_user_meta_data ->> 'phone', '')), '');
begin
  if v_role is null or v_role not in ('customer', 'venue') then
    raise exception 'invalid_role';
  end if;

  if v_role = 'customer' then
    if v_name is null then
      raise exception 'name_required';
    end if;

    insert into public.profiles (id, role, name, phone)
    values (new.id, 'customer', v_name, v_phone);
  else
    -- Venue account: name/phone live in venues only.
    insert into public.profiles (id, role)
    values (new.id, 'venue');

    insert into public.venues (account_id, name, phone)
    values (new.id, v_name, v_phone);
  end if;

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- Venue activation rule:
-- is_active = true only if setup is complete AND >= 1 active pitch.
-- ============================================================
create or replace function public.enforce_venue_activation()
returns trigger
language plpgsql
as $$
begin
  if new.is_active then
    if new.setup_completed_at is null then
      raise exception 'venue_not_ready';
    end if;
    if not exists (
      select 1 from public.pitches
      where venue_id = new.id and is_active
    ) then
      raise exception 'venue_not_ready';
    end if;
  end if;
  return new;
end;
$$;

create trigger venues_enforce_activation
  before insert or update of is_active on public.venues
  for each row execute function public.enforce_venue_activation();