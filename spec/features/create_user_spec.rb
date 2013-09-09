require 'spec_helper'

describe "User Creation Process, Anonymous Visitor" do
  it "signs up with twitter and is prompted to add firstname and lastname" do
    project = FactoryGirl.create(:project)

    add_user_mock(provider: "twitter", uid: "A MONSTER")

    visit root_url

    expect{ click_link "Sign In With Twitter" }.to change(User, :count).by 1

    fill_in 'user_first_name', with: "Bob"
    fill_in 'user_last_name', with: "Jones"
    fill_in 'user_email', with: "bobjones@gmail.com"
    fill_in 'user_password', with: "password"
    fill_in 'user_password_confirmation', with: "password"

    click_button "Update User"

    page.should have_content "Bob"
    page.should have_content "Jones"
    page.should have_content "bobjones@gmail.com"
    page.should have_content "Chicago"
  end

  it "signs up with facebook" do
    project = FactoryGirl.create(:project)

    add_user_mock(provider: "facebook", uid: "A MAN")

    visit root_url

    expect{ click_link "Sign In With Facebook" }.to change(User, :count).by 1

    page.should have_content "Bob"
  end

  it "signs up without using social media" do
    project = FactoryGirl.create(:project)

    visit root_url

    click_link "Sign In / Sign Up"

    expect{
      fill_in 'user_first_name', with: "Matt"
      fill_in 'user_last_name', with: "Thaler"
      fill_in 'user_email', with: "mthaler@gmail.com"
      fill_in 'user_location', with: "Anaheim"
      fill_in 'user_password', with: "password"
      fill_in 'user_password_confirmation', with: "password"
      click_button "Create User"
    }.to change(User, :count).by 1

    page.should have_content "Matt Thaler"
    page.should have_content "mthaler@gmail.com"
    page.should have_content "Anaheim"
  end

  it "is redirected back to creation page if info incomplete" do
    project = FactoryGirl.create(:project)

    visit root_url

    click_link "Sign In / Sign Up"

    fill_in 'user_first_name', with: "Matt"
    fill_in 'user_email', with: "mthaler@gmail.com"
    fill_in 'user_password', with: "password"
    click_button "Create User"

    page.should have_content "User Creation Failed"
  end
end
