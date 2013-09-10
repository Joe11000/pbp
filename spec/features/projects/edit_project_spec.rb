require 'spec_helper'

describe "Project Editing" do
  context "visitor" do
    it "can't edit a project" do
      project = FactoryGirl.create(:project)

      visit edit_project_url(project)

      page.should_not have_content("Create Project")

      current_url.should eq root_url
    end
  end

  context "user" do
    it "can edit their own project" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      page.fill_in("project_title",        with: project.title + " edit")
      page.fill_in("project_description",  with: project.description + " edit")
      page.fill_in("project_deadline",     with: project.deadline + 1)
      page.fill_in("project_dollar_goal",  with: project.dollar_goal + 5)
      page.fill_in("project_hour_goal",    with: project.dollar_goal + 5)

      click_button "Update Project"

      page.should_not have_content("Update Project")

      project = Project.last

      expect(project.title).to       eq (project.title)
      expect(project.description).to eq (project.description)
      expect(project.deadline).to    eq (project.deadline)
      expect(project.dollar_goal).to eq (project.dollar_goal)
    end

    it "can't edit someone elses project" do
      add_user_mock(uid: "Random User")

      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      page.should have_content("Support local projects with your time or money.")
    end
  end
end
