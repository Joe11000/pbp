require 'spec_helper'

describe "Donation Editing" do 
  context "visitor" do
    it "can't edit donations" do
      donation = FactoryGirl.create(:donation)

      visit edit_project_donation_url(donation.project, donation)

      page.should have_content("Support local projects with your time or money.")
    end
  end

  context "user" do
    it "can edit own donations" do
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      save_and_open_page
      
      test_dollar_amount = 90210
      test_hours_amount  = 99991

      fill_in "donation[hours]",         with: test_hours_amount 
      fill_in "donation[dollar_amount]", with: test_dollar_amount

      click_button "contribute"

      # Test if correctly edited
      expect(Donation.find(donation.id).dollar_amount).to eq test_dollar_amount
      expect(Donation.find(donation.id).hours).to eq test_hours_amount

      # should be redirected to a different page now
      page.should_not have_content("#donation_hours") 
    end

    it "can't edit others donations" do
      add_user_mock(uid: "CIGARETTE")
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
