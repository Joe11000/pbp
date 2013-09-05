require 'spec_helper'

describe "Donation Editing" do 
  context "visitor" do
    it "can't edit donations" do
      donation = FactoryGirl.create(:donation)

      visit edit_project_donation_url(donation.project, donation)

      page.should have_content("support local projects with your time or money.")  # should redirect home
    end
  end

  context "user" do
    it "can edit own donations" do
      add_user_mock("1234")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      page.should have_css("#donation_hours")
      page.should have_css("#donation_dollar_amount") 

      click_button "contribute"
    end

    it "can't edit others donations" do
      add_user_mock("CIGARETTE")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      page.should_not have_css("#donation_hours")
      page.should_not have_css("#donation_dollar_amount") 
     end
  end
end
