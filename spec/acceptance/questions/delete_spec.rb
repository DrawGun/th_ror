require 'rails_helper'

feature 'Delete Question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit question_path(question)

    click_on I18n.t('.questions.delete_question_button')
    expect(page).to have_content I18n.t('.questions.confirmations.deleted')
  end

  scenario 'Non-authenticated user ties to create question' do
    visit question_path(question)
    expect(page).to_not have_content I18n.t('.questions.delete_question_button')
  end
end
