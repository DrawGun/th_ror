require 'rails_helper'

feature 'Delete answer', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit question_path(question)

    within("li#answer#{answer1.id}") do
      click_on I18n.t('.answers.delete_answer_button')
    end

    expect(page).to have_content I18n.t('.answers.confirmations.deleted')
  end

  scenario 'Non-authenticated user ties to create question' do
    visit question_path(question)
    expect(page).to_not have_content I18n.t('.answers.delete_answer_button')
  end
end
