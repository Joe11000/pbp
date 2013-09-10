require 'spec_helper'

describe 'Mediafile attachment to project' do
  it 'owner can embed media in their project' do
    project = FactoryGirl.create(:project)

    add_user_mock

    visit root_url

    click_link "Sign In With Facebook"

    visit edit_project_url(project)

    click_link "Add Media"

    expect{
      fill_in "mediafile_url", with: 'http://www.youtube.com/watch?v=kfVsfOSbJY0'
      fill_in "mediafile_name", with: 'Rebecca Black Friday'
      fill_in "mediafile_media_type", with: "video"
      click_button "Update Project"
      }.to change(Mediafile, :count).by 1

    visit project_url(project)

    page.should have_css('iframe')
  end
end
