require 'rails_helper'

RSpec.feature "SignUps", type: :feature do

  background do
    visit new_user_url
  end

  scenario "user signs up" do
    fill_in 'Username', with: 'Sam_I_am'
    fill_in 'Password', with: "password321"
    click_button 'Sign Up'
    expect(page).to have_content 'Show'
  end

  scenario "user fails to sign up" do
    fill_in 'Password', with: "password321"
    click_button 'Sign Up'
    expect(page).to have_content 'Sign Up'
  end
end
