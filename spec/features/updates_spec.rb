require 'spec_helper'

describe 'Updates' do
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
    update  = FactoryGirl.create(:update)

    add_user_mock

    visit_root_url

    click_link "Sign In With Facebook"

    visit project_url(project)

    click_link 'Updates' #this should show all updates


  end
end
