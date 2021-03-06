require 'spec_helper'

describe "Homepage" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "visitor" do
    it "can view projects " do
      project = FactoryGirl.create(:project)

      visit root_url

      page.should have_content(project.title)
    end

    it "can login" do
      project = FactoryGirl.create(:project)

      add_user_mock(uid: "1234")

      visit root_url

      click_link "Sign In With Facebook"

      page.should have_content "Sign Out"
    end
  end

  context "user" do
    it "can view projects" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"
    end

    it "can enter the project create view" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      click_link "Create A Project"
    end
  end

  context "a project owner" do
    it "can enter the project edit view" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      click_link project.title

      click_link "Edit This Project"

      page.should have_css("#project_title")
      page.should have_css("#project_description")
      page.should have_css("#project_hour_goal")
      page.should have_css("#project_dollar_goal")
    end
  end
end
