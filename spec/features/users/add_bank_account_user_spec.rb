require 'spec_helper'

describe "User can add a bank account" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  it "does not show the add bank account button if project is not 100% funded" do
    project = FactoryGirl.create(:project)

    visit root_url

    click_link "Sign In With Facebook"

    visit project_url(project)

    expect( has_button?("Add Bank Account") ).to eq false
  end

  it "does not show the add bank account button if you are not allowed to edit the project" do
    project = FactoryGirl.create(:project)

    visit root_url

    visit project_url(project)

    expect( has_button?("Add Bank Account") ).to eq false
  end

  it "allows a user to add a bank account when a project is fully funded", :js => true do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    donation = FactoryGirl.create(:donation)

    donation.hours = 10000
    donation.dollar_amount = 10000
    donation.save

    project.donations << donation
    project.save
    user.created_projects << project

    visit root_path

    find(".dropdown-toggle").click

    find(:xpath, '//a[contains(text(), "Sign In With Facebook")]').click

    visit project_path(project.id)

    find(:xpath, '//a[contains(text(), "Add Bank Account")]').click

    fill_in "name", with: "zachary gershman"
    fill_in "account_num", with: "9900000002"
    fill_in "bank_code", with: "021000021"
    page.select "Checking", :from => "account_type"

    find("#bank").click

    expect( page.has_content?("Thank you for adding your bank account! Good luck with the project!") ).to eq true
  end

  it "doesn't allow a user to add a bank account when their project is not fully funded", :js => true do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)

    user.created_projects << project

    visit root_path

    find(".dropdown-toggle").click

    find(:xpath, '//a[contains(text(), "Sign In With Facebook")]').click

    visit project_path(project.id)

    expect( page.has_xpath?('//a[contains(text(), "Add Bank Account")]') ).to eq false
  end
end
