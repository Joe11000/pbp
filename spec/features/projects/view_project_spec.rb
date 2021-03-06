require "spec_helper"

describe "Project Viewing" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context "visitor" do
    it "can see all projects" do
      project = FactoryGirl.create(:project)

      visit root_url

      page.should have_content(project.title)
    end

    it "can see a project" do
      project = FactoryGirl.create(:project)

      visit project_url(project)

      page.should have_content(project.title)
      page.should have_content(project.owner.nickname)
    end

    it "can click on a linked project" do
      project = FactoryGirl.create(:project)
      project2 = FactoryGirl.create(:project)
      mediafile = FactoryGirl.create(:mediafile)
      project.mediafiles << mediafile

      visit root_url

      click_link "#{project.title}"

      current_url.should eq project_url(project)
    end
  end

  context "user" do
    it "can see all projects" do
      add_user_mock(uid: "Prezzels")

      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      page.should have_content(project.title)
    end

    it "can see a project" do
      add_user_mock(uid: "vroom")
      project = FactoryGirl.create(:project)

      visit root_url

      click_link "Sign In With Facebook"

      visit project_url(project)

      page.should have_content(project.title)
      page.should have_content(project.owner.nickname)
    end
  end
end
