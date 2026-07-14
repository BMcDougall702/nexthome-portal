-- =====================================================================
--  NextHome People First — Agent Portal  ·  database setup
--  Run this ONCE in the Supabase SQL Editor (paste it all, click Run).
--  Safe to run again later — it won't duplicate anything.
-- =====================================================================

-- ---------- 1) PROFILES: one row per user (name, role, private goal) ----------
create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text,
  role       text not null default 'agent' check (role in ('agent','admin')),
  gci_goal   numeric not null default 120000,
  created_at timestamptz not null default now()
);

-- Automatically create a profile row whenever a user is added
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.email))
  on conflict (id) do nothing;
  return new;
end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------- 2) CLOSINGS: PRIVATE to each agent ----------
create table if not exists public.closings (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users(id) on delete cascade,
  address    text not null,
  close_date date not null,
  price      numeric not null,
  side       text,
  pct        numeric not null default 2.5,
  created_at timestamptz not null default now()
);

-- ---------- 3) VIDEOS: SHARED (admins add, everyone views) ----------
create table if not exists public.videos (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  category    text,
  url         text,
  description text,
  created_at  timestamptz not null default now()
);

-- ---------- 4) DOCUMENTS: SHARED (admins add, everyone views) ----------
create table if not exists public.documents (
  id         uuid primary key default gen_random_uuid(),
  title      text not null,
  category   text,
  url        text,
  created_at timestamptz not null default now()
);

-- ---------- 5) MESSAGES: SHARED board (anyone posts; admins pin) ----------
create table if not exists public.messages (
  id          uuid primary key default gen_random_uuid(),
  author_id   uuid references auth.users(id) on delete set null,
  author_name text,
  body        text not null,
  pinned      boolean not null default false,
  created_at  timestamptz not null default now()
);

-- ---------- helper: is the current user an admin? ----------
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

-- =====================================================================
--  SECURITY RULES (Row Level Security)
-- =====================================================================
alter table public.profiles  enable row level security;
alter table public.closings  enable row level security;
alter table public.videos    enable row level security;
alter table public.documents enable row level security;
alter table public.messages  enable row level security;

-- PROFILES: you can read/update only your own (admins can read all)
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles for select
  using (id = auth.uid() or public.is_admin());
drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles for update
  using (id = auth.uid());

-- CLOSINGS: each agent sees & manages only their own
drop policy if exists closings_select on public.closings;
create policy closings_select on public.closings for select using (user_id = auth.uid());
drop policy if exists closings_insert on public.closings;
create policy closings_insert on public.closings for insert with check (user_id = auth.uid());
drop policy if exists closings_delete on public.closings;
create policy closings_delete on public.closings for delete using (user_id = auth.uid());

-- VIDEOS: everyone signed in can read; only admins can add/remove
drop policy if exists videos_select on public.videos;
create policy videos_select on public.videos for select using (auth.uid() is not null);
drop policy if exists videos_insert on public.videos;
create policy videos_insert on public.videos for insert with check (public.is_admin());
drop policy if exists videos_delete on public.videos;
create policy videos_delete on public.videos for delete using (public.is_admin());

-- DOCUMENTS: everyone reads; only admins add/remove
drop policy if exists documents_select on public.documents;
create policy documents_select on public.documents for select using (auth.uid() is not null);
drop policy if exists documents_insert on public.documents;
create policy documents_insert on public.documents for insert with check (public.is_admin());
drop policy if exists documents_delete on public.documents;
create policy documents_delete on public.documents for delete using (public.is_admin());

-- MESSAGES: everyone reads & posts; delete own (admins delete/pin any)
drop policy if exists messages_select on public.messages;
create policy messages_select on public.messages for select using (auth.uid() is not null);
drop policy if exists messages_insert on public.messages;
create policy messages_insert on public.messages for insert with check (author_id = auth.uid());
drop policy if exists messages_delete on public.messages;
create policy messages_delete on public.messages for delete using (author_id = auth.uid() or public.is_admin());
drop policy if exists messages_update on public.messages;
create policy messages_update on public.messages for update using (public.is_admin());

-- =====================================================================
--  STARTER CONTENT (so the portal isn't empty on first sign-in)
-- =====================================================================
insert into public.videos (title, category, url, description) values
  ('New Agent Onboarding — Day 1 Walkthrough','Onboarding','#','Systems, branding, and first-week checklist.'),
  ('Listing Presentation that Wins','Marketing','#','The People First listing approach, start to finish.'),
  ('MLS + Transaction Management Setup','Tech & Tools','#','Get your tech stack dialed in under 20 min.'),
  ('Nevada Disclosures — Common Mistakes','Compliance','#','Stay clean on every file.'),
  ('Las Vegas Market Update','Market Updates','#','Where Southern Nevada inventory & pricing sit now.');

insert into public.documents (title, category, url) values
  ('Nevada Residential Purchase Agreement','Forms & Disclosures','#'),
  ('Seller Net Sheet Template','Forms & Disclosures','#'),
  ('NextHome Brand Kit & Logos','Marketing Assets','#'),
  ('New Agent Onboarding Checklist','Onboarding','#'),
  ('Wiring Instructions & ABA Disclosure','Wiring & ABA','#');

insert into public.messages (author_id, author_name, body, pinned) values
  (null,'Brokerage','Welcome to the NextHome People First agent portal! 🎉 Important updates will be pinned here.', true);

-- =====================================================================
--  MAKE YOURSELF AN ADMIN
--  Run this AFTER you have created your own user (Step 4).
--  Change the email below if needed.
-- =====================================================================
update public.profiles set role = 'admin'
where id = (select id from auth.users where email = 'beau@nh-lasvegas.com');
