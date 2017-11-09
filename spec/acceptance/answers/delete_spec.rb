require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to get answer from community
  As site user
  I want to be able to delete answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user can delete his own answer' do
    sign_in(user)

    visit question_path(question)

    within("li#answer#{answer1.id}") do
      click_on I18n.t('.answers.delete_answer_button')
    end

    expect(page).to have_content I18n.t('.answers.confirmations.deleted')
    expect(page).to_not have_content answer1.body
  end

  scenario 'Authenticated user can`t delete others` answers' do
    anoter_user = create(:user)
    sign_in(anoter_user)

    visit question_path(question)

    expect(page).to have_content answer1.body
    expect(page).to_not have_content I18n.t('.answers.delete_answer_button')
  end

  scenario 'Non-authenticated user can`t delete any answers' do
    visit question_path(question)
    expect(page).to_not have_content I18n.t('.answers.delete_answer_button')
  end
end
