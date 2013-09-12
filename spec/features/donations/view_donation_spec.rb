require 'spec_helper'

describe "View Donation" do 

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "visitor" do
    it "can view all donations" do
      donation = FactoryGirl.create(:donation)

      visit project_donations_url(donation.project)

      page.should have_css("table.donations")
    end

    it "can view a donation" do
      donation = FactoryGirl.create(:donation)

      visit project_donation_url(donation.project, donation)

      page.should have_content(donation.user.fb_nickname)
      page.should have_content(donation.project.title.to_s)

      current_url.should eq project_donation_url(donation.project, donation)
    end
  end

  context "user" do
    it "can view all donations" do
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"
      
      visit project_donations_url(donation.project)

      page.should have_css("table.donations")
    end

    it "can view a donation" do
      donation = FactoryGirl.create(:donation)

      visit root_url

      click_link "Sign In With Facebook"
      
      visit project_donation_url(donation.project, donation)

      page.should have_content(donation.user.fb_nickname)
      page.should have_content(donation.project.title)

      current_url.should eq project_donation_url(donation.project, donation)
    end
  end 
end
