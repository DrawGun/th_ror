require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author of question
  I`d like to be able to edit it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)
    expect(page).to_not have_link I18n.t('.questions.edit.button')
    expect(page).to_not have_link I18n.t('.questions.edit.submit')
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit question' do
      within "#question" do
        expect(page).to have_link I18n.t('.questions.edit.button')
      end
    end

    describe 'try to edit own question' do
      scenario 'with valid attrs', :aggregate_failures do
        question_body = 'edited question'

        within "#question-info" do
          click_on I18n.t('.questions.edit.button')
          fill_in 'question_body', with: question_body
          click_on I18n.t('.questions.edit.submit')
          expect(page).to_not have_content question.body
          expect(page).to have_content question_body
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'with non-valid attrs' do
        within "#question" do
          click_on I18n.t('.questions.edit.button')
          fill_in 'question_body', with: ''
          click_on I18n.t('.questions.edit.submit')

          expect(page).to_not have_content question.body
          expect(page).to have_selector 'textarea'
        end
        expect(page).to have_content I18n.t('.questions.failure.updated')
      end
    end

    scenario 'try to edit other question' do
      another_user = create(:user)
      another_question = create(:question, user: another_user)
      visit question_path(another_question)

      within "#question" do
        expect(page).to_not have_link I18n.t('.questions.edit.button')
        expect(page).to_not have_link I18n.t('.questions.edit.submit')
      end
    end
  end
end
