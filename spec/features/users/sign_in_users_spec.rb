require 'spec_helper'

describe "user can sign into their account" do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  it "can sign in with valid credentials" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)

    visit root_url

    click_on "Sign In / Sign Up"

    fill_in "email", with: user.email
    fill_in "password", with: "foo"

    click_on "Sign In"

    expect( current_url ).to eq root_url
  end

  it "cannot sign in with invalid credentials" do
    user = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)

    visit root_url

    click_on "Sign In / Sign Up"

    p user.email

    fill_in "email", with: "b@gmail.com"
    fill_in "password", with: "foo"

    click_on "Sign In"

    expect( current_url ).to eq new_user_url
  end
end
