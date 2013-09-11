require 'spec_helper'

describe "Creating Donations" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "visitor" do
    it "can't visit donation#new page" do
      project = FactoryGirl.create(:project)

      visit new_project_donation_url(project.id)

      project = FactoryGirl.create(:project)

      current_url.should eq new_user_url
    end
  end

  context "user" do
    it "can visit donation#new page" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit new_project_donation_url(project)

      current_url.should eq new_project_donation_url(project)
    end
  end
end
