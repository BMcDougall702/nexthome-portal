-- =====================================================================
--  Agent Portal — NEW-AGENT ONBOARDING CHECKLIST
--  Run this ONCE in the Supabase SQL Editor (nexthome-portal project).
--  Safe to re-run: starter steps won't be duplicated.
-- =====================================================================

-- Shared list of steps (admins manage, all agents see)
create table if not exists public.onboarding_steps (
  id          uuid primary key default gen_random_uuid(),
  section     text not null default 'General',
  title       text not null,
  description text,
  url         text,
  sort_order  int  not null default 0,
  created_at  timestamptz not null default now(),
  unique (section, title)
);

-- Each agent's private progress (a row = that step is checked off)
create table if not exists public.onboarding_progress (
  user_id    uuid not null references auth.users(id) on delete cascade,
  step_id    uuid not null references public.onboarding_steps(id) on delete cascade,
  done       boolean not null default true,
  updated_at timestamptz not null default now(),
  primary key (user_id, step_id)
);

alter table public.onboarding_steps    enable row level security;
alter table public.onboarding_progress enable row level security;

-- Steps: everyone signed in can read; only admins add/edit/remove
drop policy if exists ob_steps_select on public.onboarding_steps;
create policy ob_steps_select on public.onboarding_steps for select using (auth.uid() is not null);
drop policy if exists ob_steps_insert on public.onboarding_steps;
create policy ob_steps_insert on public.onboarding_steps for insert with check (public.is_admin());
drop policy if exists ob_steps_update on public.onboarding_steps;
create policy ob_steps_update on public.onboarding_steps for update using (public.is_admin());
drop policy if exists ob_steps_delete on public.onboarding_steps;
create policy ob_steps_delete on public.onboarding_steps for delete using (public.is_admin());

-- Progress: each agent only sees and changes their own
drop policy if exists ob_prog_select on public.onboarding_progress;
create policy ob_prog_select on public.onboarding_progress for select using (user_id = auth.uid());
drop policy if exists ob_prog_insert on public.onboarding_progress;
create policy ob_prog_insert on public.onboarding_progress for insert with check (user_id = auth.uid());
drop policy if exists ob_prog_update on public.onboarding_progress;
create policy ob_prog_update on public.onboarding_progress for update using (user_id = auth.uid());
drop policy if exists ob_prog_delete on public.onboarding_progress;
create policy ob_prog_delete on public.onboarding_progress for delete using (user_id = auth.uid());

-- ---------- Starter steps ----------
insert into public.onboarding_steps (section,title,description,url,sort_order) values
('1. Get Licensed (Nevada)','Pass your Nevada real estate exam',$$Pass both the state and national portions of the Nevada salesperson exam. This checklist picks up right after you pass.$$,null,10),
('1. Get Licensed (Nevada)','Get fingerprinted for your background check',$$Submit fingerprints and complete the background check required by the Nevada Real Estate Division (NRED).$$,null,20),
('1. Get Licensed (Nevada)','Get Errors & Omissions (E&O) insurance',$$Obtain the E&O insurance coverage required to activate your license.$$,null,30),
('1. Get Licensed (Nevada)','Submit your license application to NRED',$$Complete your salesperson license application with the Nevada Real Estate Division and pay the fees.$$,'https://red.nv.gov/',40),
('1. Get Licensed (Nevada)','Place your license with your broker',$$Have your new license associated with the brokerage so you can start working. Talk to Beau or Ammon.$$,null,50),
('1. Get Licensed (Nevada)','Join GLVAR / Las Vegas REALTORS',$$Join the Greater Las Vegas Association of REALTORS and pay your association dues.$$,null,60),
('1. Get Licensed (Nevada)','Activate your MLS access',$$Set up your GLVAR MLS login so you can search and list. (Also linked under Resources > MLS.)$$,'https://glvar.clareityiam.net/idp/login',70),
('2. NextHome Onboarding','Access your NextHome Intranet account',$$Look for the "Welcome to NextHome" email from memberservices@nexthome.com with your username and temporary password. Log in at NextHome.com (Login, top-right). Save Member Services: 855.925.6398, memberservices@nexthome.com.$$,'https://intranet.nexthome.com/Login',110),
('2. NextHome Onboarding','Complete the NextHome Agent Orientation',$$In the intranet, open the NextHome Growth Lab, click "Launch Now", and complete the Agent Orientation course first.$$,'https://intranet.nexthome.com/Login',120),
('2. NextHome Onboarding','Set up your NextHome agent profile',$$Add a high-res headshot, personalized bio, correct contact info and direct line, email/domain, social links, languages, designations, license info, MLS credentials, notification preferences, and Media tab photos. (This profile is public.)$$,null,130),
('2. NextHome Onboarding','Update all non-NextHome systems',$$Rebrand yourself everywhere: email signature, voicemail, social media (Facebook, LinkedIn, Instagram, YouTube), state and local association / MLS profiles, Google Business page, NAR profile, RPR, real estate portals (Zillow, Realtor.com, Homes.com), FHA/HUD if applicable, and relocation companies.$$,null,140),
('2. NextHome Onboarding','Review branding guidelines & download logos',$$Read the NextHome Branding Guidelines, then download your logo files (including Luke and the HumansOverHouses logo).$$,'https://content.nexthome.com/marketing/logos/branding_guidelines.pdf',150),
('2. NextHome Onboarding','Order business cards & marketing items',$$Order through the designated suppliers (local vendors are not permitted). Claim your RealGrader digital business card and email signature. Order your name badge, notecards, letterhead, envelopes, and folders.$$,'https://intranet.nexthome.com/Marketing/BrandingCenter',160),
('2. NextHome Onboarding','Order your signage',$$Order yard signs / main panels, riders, open house directionals, and feather flags through the designated signage vendors.$$,'https://intranet.nexthome.com/Marketing/VendorsProducts',170),
('2. NextHome Onboarding','Learn your NextHome tools & services',$$Work through the Training Center courses and videos. Start with the tool that moves the needle most (for example BoldTrail CRM or Presentation Builder), master it, then move to the next.$$,null,180),
('2. NextHome Onboarding','Announce your move to your sphere',$$Use the BoldTrail Design Center to create marketing and send announcements over the next 90 days telling past and current clients about your move to NextHome.$$,'https://intranet.nexthome.com/Marketing/DesignCenter/',190),
('2. NextHome Onboarding','Review the Approved Supplier Catalog',$$Review the NextHome Approved Suppliers for discounted rates on products and services you may already use.$$,'https://content.nexthome.com/marketing/approved_supplier_catalog.pdf',200),
('3. Homework','Homework (coming soon)',$$Beau and Ammon will add homework assignments here.$$,null,900)
on conflict (section,title) do nothing;
