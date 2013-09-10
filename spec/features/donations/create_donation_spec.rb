require 'spec_helper'

describe "Creating Donations" do
  context "visitor" do
    it "can't visit donation#new page" do
      project = FactoryGirl.create(:project)

      visit new_project_donation_url(project.id)

        project = FactoryGirl.create(:project)

        visit root_url

        # should be redirected to a different page now
        page.should_not have_css("#project_title")
        expect(Project.last.title).to eq "Pretzels Project Title"

      page.should have_content("Support local projects with your time or money.")
    end
  end

  context "user" do
    it "can visit donation#new page" do
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit new_project_donation_url(project)

      page.should have_css("#donation_hours")
      page.should have_css("#donation_dollar_amount")
    end
  end
end
