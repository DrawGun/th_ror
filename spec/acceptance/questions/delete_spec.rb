require 'rails_helper'

feature 'Delete Question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path

    click_on I18n.t('.questions.ask_button')
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Example text'
    click_on I18n.t('.questions.new.submit')

    expect(page).to have_content I18n.t('.questions.confirmations.confirmed')
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on I18n.t('.questions.ask_button')

    expect(page).to have_content I18n.t('.devise.failure.unauthenticated')
  end
end
