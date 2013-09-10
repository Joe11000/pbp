require "spec_helper"

describe "Project Viewing" do
  context "visitor" do
    it "can see all projects" do
      project = FactoryGirl.create(:project)

      visit projects_url

      page.should have_content(project.title)
      page.should have_content(project.description)
    end

    it "can see a project" do
      project = FactoryGirl.create(:project)

      visit project_url(project)

      page.should have_content("Created By:")
      page.should have_content(project.description)
      page.should have_content("Project Description:")
      page.should have_content(project.description)
      page.should have_content("Givers")
    end
  end

  context "user" do
    it "can see all projects" do
      add_user_mock(uid: "Prezzels")
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit projects_url

      page.should have_content(project.title)
      page.should have_content(project.description)
    end

    it "can see a project" do
      add_user_mock(uid: "vroom")
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit project_url(project)

      page.should have_content("Created By:")
      page.should have_content(project.description)
      page.should have_content("Project Description:")
      page.should have_content(project.description)
      page.should have_content("Givers")
    end
  end
end
