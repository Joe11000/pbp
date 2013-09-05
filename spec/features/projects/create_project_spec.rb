require 'spec_helper'

describe "Project Creation" do
  context "user" do
    it "can create project" do 
        add_user_mock("1234")

        project = FactoryGirl.create(:project)
        
        visit root_url

        click_link "Sign In With Facebook"

        click_link "Create A Project"

        fill_in "project[title]",       with: "Pretzels Project Title"
        fill_in "project[description]", with: "Pretzels Project Description"
        fill_in "project[hour_goal]",   with: "15"
        fill_in "project[dollar_goal]", with: "15"

        click_button "Create Project"
    end
  end

  context "visitor" do
    it "cant create project" do
        project = FactoryGirl.create(:project)

        visit root_url

        click_link "Create A Project"

        page.should_not have_css("#project_title")
        page.should_not have_css("#project_description")
        page.should_not have_css("#project_hour_goal")
        page.should_not have_css("#project_dollar_goal")

        page.should have_content("support local projects with your time or money.")
    end
  end
end
