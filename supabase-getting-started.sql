-- =====================================================================
--  Onboarding: add a "Getting Started" section (about the portal) and
--  tidy the section labels. Run in the SQL Editor. Safe to re-run.
-- =====================================================================

-- Drop the numeric prefixes so "Getting Started" can lead cleanly
update public.onboarding_steps set section = 'Get Licensed (Nevada)' where section = '1. Get Licensed (Nevada)';
update public.onboarding_steps set section = 'NextHome Onboarding'    where section = '2. NextHome Onboarding';
update public.onboarding_steps set section = 'Homework'               where section = '3. Homework';

-- Move the display-name step into Getting Started (remove the old copy if it exists)
delete from public.onboarding_steps where title = 'Set your display name in the portal';

insert into public.onboarding_steps (section,title,description,url,sort_order) values
('Getting Started','Welcome to your agent portal',$$This portal is your home base. From the menu on the left you can track your closings and commission goal, watch training videos, grab forms and documents, follow the buyer/seller Playbook, message the team, and work through this onboarding checklist. Take a minute to click through each tab.$$,null,1),
('Getting Started','Set your display name',$$Click your name in the top-right corner and change it to your real name. This is how you appear on the message board and throughout the portal.$$,null,2),
('Getting Started','Explore your tools',$$Check out the Video Library (training), the Document Center (forms and files), and Quick Tools (commission and mortgage calculators).$$,null,3),
('Getting Started','Set your annual GCI goal',$$Open the Closing Tracker and set your yearly commission goal so your dashboard can track your progress all year.$$,null,4),
('Getting Started','Say hello on the Message Board',$$Post a quick introduction so the rest of the team knows you have joined.$$,null,5),
('Getting Started','Save the portal to your phone',$$Open the portal link in your phone browser and add it to your home screen for one-tap access anytime.$$,null,6)
on conflict (section,title) do nothing;
