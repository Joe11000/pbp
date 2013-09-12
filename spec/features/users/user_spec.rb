require 'spec_helper'

describe User do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "When a users visits sign in" do
    it "can sign in with valid credentials" do
      user = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: user.email
      fill_in "password", with: "foo"

      click_on "Sign In"

      expect( current_url ).to eq root_url
    end

    it "cannot sign in with invalid credentials" do
      user = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: "b@gmail.com"
      fill_in "password", with: "foo"

      click_on "Sign In"

      expect( current_url ).to eq new_user_url
    end
  end

  context "When a user visits their profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:project) { FactoryGirl.create(:project) }

    it "shows a list of projects they have donated to" do
      donation = FactoryGirl.create(:donation)
      donation.hours = 1000
      donation.dollar_amount = 1000
      donation.save
      project.donations << donation
      project.save
      user.donated_projects << project
      user.save

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: user.email
      fill_in "password", with: "foo"

      click_on "Sign In"
      click_on "View Profile"

      expect( page.has_content?("Dollars Donated:") ).to eq true
    end

    it "shows a list of projects they have created" do
      user.created_projects << project
      user.save

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: user.email
      fill_in "password", with: "foo"

      click_on "Sign In"
      click_on "View Profile"

      expect( page.has_content?("Not Funded") ).to eq true
    end

    it "has help text if they have no created projects" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: user.email
      fill_in "password", with: "foo"

      click_on "Sign In"
      click_on "View Profile"

      expect( page.has_content?("Find a project you are passionate about today:") ).to eq true
    end

    it "has help text if they have no projects donated to" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_on "Sign In / Sign Up"

      fill_in "email", with: user.email
      fill_in "password", with: "foo"

      click_on "Sign In"
      click_on "View Profile"

      expect( page.has_content?("You Don't Seem to have any projects, go make change:") ).to eq true
    end
  end
end
