require 'spec_helper'

describe 'Mediafile attachment to project' do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  it 'owner can embed media in their project' do
    project = FactoryGirl.create(:project)

    add_user_mock

    visit root_url

    click_link "Sign In With Facebook"

    visit edit_project_url(project)

    expect{
      fill_in "project_description", with: '<iframe width="420" height="315" src="//www.youtube.com/embed/My2FRPA3Gf8" frameborder="0" allowfullscreen></iframe>'
      click_button "Update Project"
      }.to change(Mediafile, :count).by 1
  end
end
