-- ============================================================
-- Buckets
--   venue-covers: public read; venue accounts write in <auth.uid()>/
--   avatars:      private; each user only in their own <auth.uid()>/
-- ============================================================
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('venue-covers', 'venue-covers', true,  5242880, array['image/jpeg', 'image/png', 'image/webp']),
  ('avatars',      'avatars',      false, 2097152, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- ============================================================
-- venue-covers policies
-- Public bucket => files are readable by URL, so no SELECT policy
-- is needed for display. Venue accounts can still list/manage
-- their own folder.
-- ============================================================
create policy venue_covers_select_own on storage.objects
  for select to authenticated
  using (
    bucket_id = 'venue-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy venue_covers_insert_own on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'venue-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
    and public.current_role_name() = 'venue'
  );

create policy venue_covers_update_own on storage.objects
  for update to authenticated
  using (
    bucket_id = 'venue-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
    and public.current_role_name() = 'venue'
  )
  with check (
    bucket_id = 'venue-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy venue_covers_delete_own on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'venue-covers'
    and (storage.foldername(name))[1] = auth.uid()::text
    and public.current_role_name() = 'venue'
  );

-- ============================================================
-- avatars policies: private, own folder only
-- ============================================================
create policy avatars_select_own on storage.objects
  for select to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy avatars_insert_own on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy avatars_update_own on storage.objects
  for update to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy avatars_delete_own on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );