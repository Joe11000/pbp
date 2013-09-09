require 'spec_helper'

describe "Project Editing" do
  context "visitor" do
    it "can't edit a project" do
      project = FactoryGirl.create(:project) # when visitor gets redirected to root, this will make it root not explode

      visit edit_project_url(project)

      page.should_not have_css("#project_title")
      page.should_not have_css("#project_description")
      page.should_not have_css("#project_hour_goal")
      page.should_not have_css("#project_dollar_goal")

      page.should have_content("Support local projects with your time or money.") # they should have been redirected home
    end
  end

  context "user" do
    it "can edit their own project" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      page.should have_field("project[title]",        with: project.title)
      page.should have_field("project[description]",  with: project.description)

      ##!!!! This one should be working. Why Can't it find deadline field on the screeen!? I am looking right at it
      page.should have_field("project[deadline]",     with: project.deadline)
      ##!!!! This one should be working. Why Can't it find deadline field on the screeen!? I am looking right at it

      page.should have_field("project[dollar_goal]",  with: project.dollar_goal)
      page.should have_field("project[hour_goal]",    with: project.hour_goal)

      page.fill_in("project[title]",        with: project.title + " edit")
      page.fill_in("project[description]",  with: project.description + " edit")
      page.fill_in("project[deadline]",     with: project.deadline + 1)
      page.fill_in("project[dollar_goal]",  with: project.dollar_goal + 5)
      page.fill_in("project[hour_goal]",    with: project.dollar_goal + 5)

      click_button "Update Project"

      # should not be on the same page
      page.should_not have_content("Update Project")

      # check for successful update
      expect(Project.find(project.id).title).to       eq (project.title + " edit")
      expect(Project.find(project.id).description).to eq (project.description + " edit")
      expect(Project.find(project.id).deadline).to    eq (project.deadline + 1.day)
      expect(Project.find(project.id).dollar_goal).to eq (project.dollar_goal + 5)
    end

    it "can't edit someone elses project" do
      add_user_mock(uid: "Random User")

      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      # should be on redirected page and edit page
      page.should_not have_css("#project_title")
      page.should_not have_css("#project_description")
      page.should_not have_css("#project_hour_goal")
      page.should_not have_css("#project_dollar_goal")

      page.should have_content("Support local projects with your time or money.")
    end
  end
end
