require 'rails_helper'

feature 'Create Question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user can see validation errors, if question invalid' do
    sign_in(user)
    visit questions_path
    click_on I18n.t('.questions.ask_button')

    click_on I18n.t('.questions.new.submit')

    expect(page).to have_content I18n.t('.questions.failure.created')
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Authenticated user can creates question' do
    sign_in(user)
    visit questions_path
    click_on I18n.t('.questions.ask_button')

    example_body = 'Example text'
    example_title = 'Test question'
    fill_in 'Body', with: example_body
    fill_in 'Title', with: example_title

    click_on I18n.t('.questions.new.submit')

    expect(page).to have_content I18n.t('.questions.confirmations.created')
    expect(page).to have_content example_body
    expect(page).to have_content example_title
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on I18n.t('.questions.ask_button')

    expect(page).to have_content I18n.t('.devise.failure.unauthenticated')
  end
end
