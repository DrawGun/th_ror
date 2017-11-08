require_relative '../acceptance_helper'

feature 'Delete Question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to delete question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user can delete his own question' do
    sign_in(user)

    visit question_path(question)

    click_on I18n.t('.questions.delete_question_button')
    expect(page).to have_content I18n.t('.questions.confirmations.deleted')
    expect(page).to_not have_content question.body
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user can`t delete others` questions' do
    anoter_user = create(:user)
    sign_in(anoter_user)

    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content question.title
    expect(page).to_not have_content I18n.t('.questions.delete_question_button')
  end

  scenario 'Non-authenticated user can`t delete any questions' do
    visit question_path(question)
    expect(page).to_not have_content I18n.t('.questions.delete_question_button')
  end
end
