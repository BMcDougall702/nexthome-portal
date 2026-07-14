-- =====================================================================
--  Onboarding HOMEWORK — NextHome Agent Workflow (buyer & seller flows)
--  Run in the Supabase SQL Editor (nexthome-portal project). Safe to re-run.
-- =====================================================================

-- Remove the "coming soon" placeholder now that real homework exists
delete from public.onboarding_steps
where section = '3. Homework' and title = 'Homework (coming soon)';

insert into public.onboarding_steps (section,title,description,url,sort_order) values
('3. Homework','Read the Agent Workflow guide',$$Read the NextHome "Agent Workflow - Using the NextHome Tools" guide, then work through the buyer and seller practice steps below. Find the guide in the Document Center (Onboarding), or ask Beau or Ammon.$$,null,905),

('3. Homework','Buyer flow - Buyer consultation',$$Review the Buyer's Agent Manual. Share your RealGrader digital business card. In BoldTrail CRM: create the client profile, add a Market Activity Report, add their birthday, and assign a campaign. In Present: build the "Win Representation" presentation and include the Buyer Agency Agreement. In SkySlope: create the Buyer Agency Agreement in Forms. Set up a search alert in NextConnect or RealScout. Connect the buyer with NextMortgage where available.$$,null,910),
('3. Homework','Buyer flow - After signing the Buyer Agency Agreement',$$In Present: set up a Buyer Tour, and run a CMA with the "Win The Offer" presentation when they are ready to offer. In BoldTrail: change status to Client, assign the active-buyer smart campaign, set recurring follow-up tasks. Use CubiCasa for floor plans on homes of interest. In SkySlope: complete Forms, send for signature in DigiSign, link the file, and attach signed documents to the checklist.$$,null,920),
('3. Homework','Buyer flow - After the offer is accepted',$$Add the contract to the NextHome Reporting System (confirm NextHome Concierge and Reach150 are set up). In BoldTrail: update status to Contract. In SkySlope: continue the compliance checklist by uploading documents.$$,null,930),
('3. Homework','Buyer flow - Upon closing',$$Tell your broker so they mark it sold in the reporting system. In BoldTrail: add Home Purchase Anniversary, set status to Closed, set up a home valuation, add the pastclient hashtag. In Design Center: create Just Sold pieces and post to social. In NextConnect: show the client their home valuation and the Quarterly Home Maintenance list.$$,null,940),

('3. Homework','Seller flow - Pre-listing appointment',$$Review the Listing Agent Manual. Share your RealGrader card. In BoldTrail: create client profile, add birthday, assign a campaign. In Present: build the "Win The Listing" presentation. In RealScout: test the market and reverse prospect. In SkySlope: complete the listing agreement in Forms and send via DigiSign. Consider NextHome Refresh (up to $50,000 to get the home market-ready with no upfront cost).$$,null,950),
('3. Homework','Seller flow - After winning the listing',$$In BoldTrail: set status to Client, assign a campaign, complete the Listing Playbook. In CubiCasa: generate a floor plan (required on all listings as of July 1, 2026). Add the listing to the NextHome Reporting System with seller contact and open house info. In Design Center: advertise the listing and post to social. In SkySlope: complete Forms, send via DigiSign, create the listing, attach signed docs. Set up a seller report via National Listing Distribution. Use the BoldTrail Open House app if hosting an open house.$$,null,960),
('3. Homework','Seller flow - Upon accepted offer',$$Add the contract to the NextHome Reporting System (confirm Concierge and Reach150). In SkySlope: continue the compliance checklist. In Design Center: use the Pending pieces and post to social. In BoldTrail: change status to Contract.$$,null,970),
('3. Homework','Seller flow - Upon closing',$$Tell your broker so they mark it sold. In BoldTrail: set status to Closed and add the pastclient hashtag. In Design Center: create Just Sold pieces and post to social.$$,null,980)
on conflict (section,title) do nothing;
