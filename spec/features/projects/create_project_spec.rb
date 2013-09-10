require 'spec_helper'

describe "Project Creation" do
  context "user" do
    it "can create project" do
        project = FactoryGirl.create(:project)

        visit root_url

        click_link "Sign In With Facebook"

        click_link "Create A Project"

        expect{
          fill_in "project_title",       with: "Pretzels Project Title"
          fill_in "project_description", with: "Pretzels Project Description"
          fill_in "project_hour_goal",   with: "15"
          fill_in "project_dollar_goal", with: "15"
          fill_in "project_deadline",    with: DateTime.now + 10
          click_button "Create Project"
        }.to change(Project, :count).by 1

        current_url.should eq project_url(Project.last)

        page.should have_content("Pretzels Project Title")
        page.should have_content("Pretzels Project Description")
    end
  end

  it "visitor is redirected to sign in / sign up" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Create A Project"

      current_url.should eq new_user_url
  end
end
