require 'spec_helper'

describe 'User Can Update Project' do
  it 'owner can add title and text to updates' do
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
end
