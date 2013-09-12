require 'spec_helper'

describe "Project Editing" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "visitor" do
    it "can't edit a project" do
      project = FactoryGirl.create(:project)

      visit edit_project_url(project)

      page.should_not have_content("Create Project")

      current_url.should eq new_user_url
    end
  end

  context "user" do
    it "can edit their own project" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      page.fill_in "project_title",        with: project.title + " edit"
      page.fill_in "project_description",  with: project.description + " edit"
      page.fill_in "project_deadline",     with: project.deadline + 1
      page.fill_in "project_dollar_goal",  with: project.get_dollar_goal + 5
      page.fill_in "project_hour_goal",    with: project.hour_goal + 5

      click_button "Update Project"

      current_url.should eq project_url(project)

      project = Project.last

      page.should have_content(project.title)
      page.should have_content(project.description)
      page.should have_content(project.deadline.strftime("%m/%d/%Y"))
      page.should have_content(project.get_dollar_goal)
    end

    it "can't edit a project unless all required info is provided" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      page.fill_in "project_title", with: nil

      click_button "Update Project"

      page.should have_content("Unsuccessful Update")

      current_url.should eq project_url(project)

    end

    it "can't edit someone elses project" do
      add_user_mock(uid: "Random User")

      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit edit_project_url(project)

      current_url.should eq new_user_url
    end
  end
end
