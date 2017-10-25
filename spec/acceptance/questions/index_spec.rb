require 'rails_helper'

feature 'Index questions', %q{
  In order to get answer from community
  I want to be able to see questions list
} do

  given(:user) { create(:user) }
  given!(:question1) { create(:question) }
  given!(:question2) { create(:question) }
  given!(:question3) { create(:question) }

  scenario 'Authenticated user can see questions' do
    sign_in(user)

    visit root_path

    expect(page).to have_content question1.title
    expect(page).to have_content question2.title
    expect(page).to have_content question3.title
  end

  scenario 'Non-authenticated user can see questions' do
    visit questions_path

    expect(page).to have_content question1.title
    expect(page).to have_content question2.title
    expect(page).to have_content question3.title
  end
end
