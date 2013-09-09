require 'spec_helper'

describe "Donation Editing" do 
  context "visitor" do
    it "can't edit donations" do
      donation = FactoryGirl.create(:donation)

      visit edit_project_donation_url(donation.project, donation)

      page.should have_content("Support local projects with your time or money.")  # should redirect home
    end
  end

  context "user" do
    it "can edit own donations" do
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      page.should have_css("#donation_hours")
      page.should have_css("#donation_dollar_amount") 

        proj_title       = "Pretzels Project Title"
        proj_desc        = "Pretzels Project Description"
        proj_hour_goal   = "15"
        proj_dollar_goal = "15"
        proj_deadline    = DateTime.now + 10

        expect{fill_in "project[title]",       with: proj_title
               fill_in "project[description]", with: proj_desc
               fill_in "project[hour_goal]",   with: proj_hour_goal
               fill_in "project[dollar_goal]", with: proj_dollar_goal
               fill_in "project[deadline]",    with: proj_deadline}.to change(Project, :count).by 1

        click_button "Create Project"

        # is the last Project the one we just created?
        proj_just_created = Project.last
        expect(proj_just_created.title).to eq proj_title
        expect(proj_desc).to eq proj_desc
        expect(proj_hour_goal).to eq proj_hour_goal
        expect(proj_dollar_goal).to eq proj_dollar_goal
        expect(proj_deadline).to eq proj_deadline

        # should be redirected to a different page now
        page.should_not have_css("#project_title") 
        expect(Project.last.title).to eq "Pretzels Project Title"


    end

    it "can't edit others donations" do
      add_user_mock("CIGARETTE")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      page.should_not have_css("#donation_hours")
      page.should_not have_css("#donation_dollar_amount") 

      page.should have_content("Support local projects with your time or money.")
     end
  end
end
