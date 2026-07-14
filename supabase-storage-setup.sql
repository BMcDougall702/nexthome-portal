-- =====================================================================
--  Agent Portal — add secure FILE UPLOADS for documents
--  Run this ONCE in the Supabase SQL Editor. Safe to re-run.
-- =====================================================================

-- Remember which documents are uploaded files (vs. external links)
alter table public.documents add column if not exists storage_path text;

-- Create a PRIVATE storage bucket to hold the uploaded files
insert into storage.buckets (id, name, public)
values ('documents', 'documents', false)
on conflict (id) do nothing;

-- Access rules for the files:
--  • any signed-in agent can open a document
--  • only admins can upload or delete files
drop policy if exists "portal docs read"   on storage.objects;
create policy "portal docs read" on storage.objects for select
  using (bucket_id = 'documents' and auth.uid() is not null);

drop policy if exists "portal docs upload" on storage.objects;
create policy "portal docs upload" on storage.objects for insert
  with check (bucket_id = 'documents' and public.is_admin());

drop policy if exists "portal docs delete" on storage.objects;
create policy "portal docs delete" on storage.objects for delete
  using (bucket_id = 'documents' and public.is_admin());
