require 'spec_helper'

describe "Donation Editing" do
  context "visitor" do
    it "can't edit donations" do
      donation = FactoryGirl.create(:donation)

      visit edit_project_donation_url(donation.project, donation)

      current_url.should eq new_user_url
    end
  end

  context "user" do
    # it "can edit own donations" do
    #   donation = FactoryGirl.create(:donation)

    #   visit root_url

    #   click_link "Sign In With Facebook"

    #   visit edit_project_donation_url(donation.project, donation)

    #   fill_in "donation_hours",         with: 10000
    #   fill_in "donation_dollar_amount", with: 10000

    #   click_button "Contribute"

    #   Needs to have test conditions written
    # end

    it "can't edit others donations" do
      add_user_mock(uid: "CIGARETTE")
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_donation_url(donation.project, donation)

      current_url.should eq new_user_url
     end
  end
end
