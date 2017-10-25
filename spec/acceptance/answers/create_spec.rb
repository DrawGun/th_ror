require 'rails_helper'

feature 'Create Question answers', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to create answer for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  scenario 'Authenticated user can creates answer for question' do
    sign_in(user)

    visit question_path(question)

    within('#create_answer') do
      fill_in 'Body', with: 'Example text'
      click_on I18n.t('.answers.new.submit')
    end

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-authenticated can not create answer for question' do
    visit questions_path
    click_on I18n.t('.questions.ask_button')

    expect(page).to have_content I18n.t('.devise.failure.unauthenticated')
  end
end
