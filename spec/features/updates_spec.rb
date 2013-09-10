require 'spec_helper'

describe 'Updates' do
  around(:each) do |example|
   VCR.use_cassette('balanced') do
     example.run
   end
  end

  it 'owner can create and view' do
    project = FactoryGirl.create(:project)

    add_user_mock

    visit root_url

    click_link 'Sign In With Facebook'

    visit project_url(project)

    click_link 'Add an Update'

    expect {
      fill_in 'update_title', with: 'My Project Update'
      fill_in 'update_body', with: "It's time to begin..."
      click_button 'Create Update'
     }.to change(Update, :count).by 1

     page.should have_text("My Project Update")
  end

  it "can edit, update and delete Updates" do
    project = FactoryGirl.create(:project)
    update  = FactoryGirl.create(:update, project: project)

    add_user_mock

    visit root_url

    click_link "Sign In With Facebook"

    visit project_url(project)

    click_link 'Updates'

    click_link 'BACON'

    click_link 'Edit'

    fill_in 'update_title', with: 'My Project'
    fill_in 'update_body', with: "It's time to begin..."
    click_button 'Create Update'

    page.should have_text("My Project")
  end

  it "owner can delete updates" do 
    project = FactoryGirl.create(:project)
    update  = FactoryGirl.create(:update, project: project)

    add_user_mock

    visit root_url

    click_link "Sign In With Facebook"

    visit project_url(project)

    click_link 'Updates'

    click_link 'BACON'

    expect {
      click_button 'Delete'
    }.to change(Update, :count).by -1

  end 
end
