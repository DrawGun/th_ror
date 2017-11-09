require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of answer
  I`d like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link I18n.t('.answers.edit.button')
    expect(page).to_not have_link I18n.t('.answers.edit.submit')
  end

  describe 'Authenticated user', js: true do
    given(:another_user) { create(:user) }
    given!(:another_answer) { create(:answer, question: question, user: another_user) }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within "#answer#{answer.id}" do
        expect(page).to have_link I18n.t('.answers.edit.button')
      end
    end

    scenario 'try to edit own answer' do
      answer_body = 'edited answer'

      within "#answer#{answer.id}" do
        click_on I18n.t('.answers.edit.button')
        fill_in 'answer_body', with: answer_body
        click_on I18n.t('.answers.edit.submit')

        expect(page).to_not have_content answer.body
        expect(page).to have_content answer_body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit other answer' do
      within "#answer#{another_answer.id}" do
        expect(page).to_not have_link I18n.t('.answers.edit.button')
        expect(page).to_not have_link I18n.t('.answers.edit.submit')
      end
    end
  end
end
