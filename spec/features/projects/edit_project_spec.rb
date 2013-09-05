require 'spec_helper'

describe "Project Editing" do
  context "visitor" do
    it "can't edit a project" do
      project = FactoryGirl.create(:project) # when visitor gets redirected to root, this will make it root not explode

      visit "/projects/#{project.id}/edit"

      page.should_not have_css("#project_title")
      page.should_not have_css("#project_description")
      page.should_not have_css("#project_hour_goal")
      page.should_not have_css("#project_dollar_goal")

      page.should have_css("h1", text: "support local projects with your time or money.") # they should have been redirected home
    end
  end

  context "user" do
    it "can edit their own project" do
      add_user_mock("1234")
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit "/projects/#{project.id}/edit"

      page.should have_field("project[description]", with: "A test project that requires lots of stuff and doing.")
      page.should have_field("project[hour_goal]",   with: "100")
      page.should have_field("project[dollar_goal]", with: "100")

      page.fill_in("project[description]", with: "This test has been edited")

    # Add These once deadline has been added
      # click_button "Update Project"
      # page.should have_content("support local projects with your time or money.") # they should have been redirected home
    end

    it "can't edit someone elses project" do
      user = add_user_mock
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      # should be on redirected page and edit page
      page.should_not have_css("#project_title")
      page.should_not have_css("#project_description")
      page.should_not have_css("#project_hour_goal")
      page.should_not have_css("#project_dollar_goal")

      page.should have_content("support local projects with your time or money.")
    end
  end
end
