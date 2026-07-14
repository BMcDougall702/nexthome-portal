-- =====================================================================
--  Move the buyer/seller workflow OUT of Homework (it now lives on the
--  new Playbook page). Homework keeps one step that points agents there.
--  Run in the Supabase SQL Editor (nexthome-portal project). Safe to re-run.
-- =====================================================================

delete from public.onboarding_steps
where section = '3. Homework'
  and title in (
    'Read the Agent Workflow guide',
    'Buyer flow - Buyer consultation',
    'Buyer flow - After signing the Buyer Agency Agreement',
    'Buyer flow - After the offer is accepted',
    'Buyer flow - Upon closing',
    'Seller flow - Pre-listing appointment',
    'Seller flow - After winning the listing',
    'Seller flow - Upon accepted offer',
    'Seller flow - Upon closing'
  );

insert into public.onboarding_steps (section,title,description,url,sort_order) values
('3. Homework','Study the Agent Playbook (buyer & seller workflow)',$$Open the Playbook tab and read through the full Buyer and Seller workflows. Learn which NextHome tool to use at each stage, from first meeting to closing.$$,null,905)
on conflict (section,title) do nothing;
