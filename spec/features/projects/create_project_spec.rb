require 'spec_helper'

describe "Project Creation" do
  context "user" do
    it "can create project" do 
        add_user_mock("1234")

        project = FactoryGirl.create(:project)
        
        visit root_url

        click_link "Sign In With Facebook"

        click_link "Create A Project"

        proj_title       = "Pretzels Project Title"
        proj_desc        = "Pretzels Project Description"
        proj_hour_goal   = "15"
        proj_dollar_goal = "15"
        proj_deadline    = DateTime.now + 10

        expect(fill_in "project[title]",       with: proj_title
               fill_in "project[description]", with: proj_desc
               fill_in "project[hour_goal]",   with: proj_hour_goal
               fill_in "project[dollar_goal]", with: proj_dollar_goal
               fill_in "project[deadline]",    with: proj_deadline).to change(Project, :count).by 1

        click_button "Create Project"

        # is the last Project the one we just created?
        proj_just_created = Project.last
        expect(proj_just_created.title).to eq proj_title
        expect(proj_desc).to eq proj_desc
        expect(proj_hour_goal).to eq proj_hour_goal
        expect(proj_dollar_goal).to eq proj_dollar_goal
        expect(proj_deadline).to eq proj_deadline

        # should be redirected to a different page now
        page.should_not have_css("#project_title") 
        expect(Project.last.title).to eq "Pretzels Project Title"

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
