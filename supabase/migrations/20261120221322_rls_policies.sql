-- ============================================================
-- Privileges: start from zero, grant only what the app needs.
-- (Supabase grants broad defaults to anon/authenticated.)
-- ============================================================
revoke all on public.profiles       from anon, authenticated;
revoke all on public.venues         from anon, authenticated;
revoke all on public.pitches        from anon, authenticated;
revoke all on public.bookings       from anon, authenticated;
revoke all on public.venue_blocks   from anon, authenticated;
revoke all on public.notifications  from anon, authenticated;
revoke all on public.device_tokens  from anon, authenticated;

-- Helper functions: signed-in users only.
revoke execute on function public.current_role_name()      from public, anon;
revoke execute on function public.my_venue_id()            from public, anon;
revoke execute on function public.venue_is_public(uuid)    from public, anon;
grant  execute on function public.current_role_name()      to authenticated;
grant  execute on function public.my_venue_id()            to authenticated;
grant  execute on function public.venue_is_public(uuid)    to authenticated;

-- Trigger functions are never called by clients.
revoke execute on function public.handle_new_user()          from public, anon, authenticated;
revoke execute on function public.enforce_venue_activation() from public, anon, authenticated;

-- ============================================================
-- profiles: read own; update only name, phone, avatar_url, locale
-- ============================================================
grant select on public.profiles to authenticated;
grant update (name, phone, avatar_url, locale) on public.profiles to authenticated;

create policy profiles_select_own on public.profiles
  for select to authenticated
  using (id = auth.uid());

create policy profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- ============================================================
-- venues: no insert/delete from clients.
-- Update only safe columns (not account_id, not setup_completed_at).
-- ============================================================
grant select on public.venues to authenticated;
grant update (
  name, phone, area, address, description,
  latitude, longitude, cover_url,
  opening_time, closing_time, is_active
) on public.venues to authenticated;

create policy venues_select on public.venues
  for select to authenticated
  using (
    account_id = auth.uid()
    or public.venue_is_public(id)
    or exists (
      select 1 from public.bookings b
      where b.venue_id = venues.id and b.customer_id = auth.uid()
    )
  );

create policy venues_update_own on public.venues
  for update to authenticated
  using (account_id = auth.uid())
  with check (account_id = auth.uid());

-- ============================================================
-- pitches: venue account inserts/updates own (no delete);
-- customers read active pitches of public venues, plus pitches
-- of venues they booked at.
-- ============================================================
grant select on public.pitches to authenticated;
grant insert (venue_id, name, size, description, price, duration_minutes, is_active)
  on public.pitches to authenticated;
grant update (name, size, description, price, duration_minutes, is_active)
  on public.pitches to authenticated;

create policy pitches_select on public.pitches
  for select to authenticated
  using (
    venue_id = public.my_venue_id()
    or (is_active and public.venue_is_public(venue_id))
    or exists (
      select 1 from public.bookings b
      where b.venue_id = pitches.venue_id and b.customer_id = auth.uid()
    )
  );

create policy pitches_insert_own on public.pitches
  for insert to authenticated
  with check (venue_id = public.my_venue_id());

create policy pitches_update_own on public.pitches
  for update to authenticated
  using (venue_id = public.my_venue_id())
  with check (venue_id = public.my_venue_id());

-- ============================================================
-- bookings: read only. All writes go through RPCs.
-- ============================================================
grant select on public.bookings to authenticated;

create policy bookings_select on public.bookings
  for select to authenticated
  using (
    customer_id = auth.uid()
    or venue_id = public.my_venue_id()
  );

-- ============================================================
-- venue_blocks: venue account reads own; writes via RPC.
-- Customers read nothing.
-- ============================================================
grant select on public.venue_blocks to authenticated;

create policy venue_blocks_select_own on public.venue_blocks
  for select to authenticated
  using (venue_id = public.my_venue_id());

-- ============================================================
-- notifications: read own; update only read_at. Inserts via RPCs.
-- ============================================================
grant select on public.notifications to authenticated;
grant update (read_at) on public.notifications to authenticated;

create policy notifications_select_own on public.notifications
  for select to authenticated
  using (user_id = auth.uid());

create policy notifications_update_own on public.notifications
  for update to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ============================================================
-- device_tokens: read/delete own; register via RPC.
-- ============================================================
grant select, delete on public.device_tokens to authenticated;

create policy device_tokens_select_own on public.device_tokens
  for select to authenticated
  using (user_id = auth.uid());

create policy device_tokens_delete_own on public.device_tokens
  for delete to authenticated
  using (user_id = auth.uid());