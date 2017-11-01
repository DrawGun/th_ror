require 'rails_helper'

feature 'Create Question answers', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to create answer for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  scenario 'Authenticated user can creates answer for question', js: true do
    example_title = 'Example text'
    sign_in(user)

    visit question_path(question)

    within('#create_answer') do
      fill_in 'Body', with:example_title
      click_on I18n.t('.answers.new.submit')
    end

    expect(page).to have_content example_title
    # expect(page).to have_content I18n.t('.answers.confirmations.created')
  end

  scenario 'Non-authenticated can not create answer for question' do
    visit question_path(question)
    expect(page).to_not have_content I18n.t('.answers.new.submit')
  end

  scenario 'User can see validation errors, if answer invalid' do
    sign_in(user)
    visit question_path(question)
    within('#create_answer') do
      click_on I18n.t('.answers.new.submit')
    end

    expect(page).to have_content I18n.t('.answers.failure.created')
    expect(page).to have_content "Body can't be blank"
  end
end
