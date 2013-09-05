require 'spec_helper'

describe "View Donation" do 
  context "visitor" do
    it "can view all donations" do
      donation = FactoryGirl.create(:donation)

      visit project_donations_url(donation.project)

      page.should have_css("table.donations")
    end

    it "can view a donations" do
      donation = FactoryGirl.create(:donation)

      visit project_donation_url(donation.project, donation)

      page.should have_content(donation.user.fb_nickname)
      page.should have_content(donation.hours)
      page.should have_content("$" + donation.dollar_amount.to_s)
    end
  end

  context "user" do
    it "can view all donations" do
      add_user_mock("1234")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"
      
      visit project_donations_url(donation.project)

      page.should have_css("table.donations")
    end

    it "can view a donations" do
      add_user_mock("1234")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"
      
      visit project_donation_url(donation.project, donation)

      page.should have_content(donation.user.fb_nickname)
      page.should have_content(donation.hours)
      page.should have_content("$" + donation.dollar_amount.to_s)
    end
    # page.should have_content('support local projects with your time or money.') 
  end 
end
