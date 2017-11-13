require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to mark best answer
  As an authenticated author of answer
  I`d like to be able to mark_as_best answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }
  given!(:answer3) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to set best answer' do
    visit question_path(question)
    expect(page).to_not have_link I18n.t('.answers.set_best_button')
    expect(page).to_not have_link I18n.t('.answers.set_best_button')
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees Set best answer link' do
      within "#answer#{answer1.id}" do
        expect(page).to have_link I18n.t('.answers.set_best_button')
      end
    end

    scenario 'try to set best answer for other answer' do
      another_user = create(:user)
      another_question = create(:question, user: another_user)
      another_answer = create(:answer, question: another_question, user: another_user)
      visit question_path(another_question)

      within "#answer#{another_answer.id}" do
        expect(page).to_not have_link I18n.t('.answers.set_best_button')
        expect(page).to_not have_link I18n.t('.answers.set_best_button')
      end
    end

    describe 'click set_best_button' do
      before do
        within "#answer#{answer1.id}" do
          click_on I18n.t('.answers.set_best_button')
        end
      end

      scenario 'and marks answer as best' do
        expect(page).to have_content I18n.t('.answers.confirmations.mark_as_best')
        expect(page.find('.best_answer')).to have_text(answer1.body)
        expect(first('.answer')).to have_text(answer1.body)
      end

      describe 'then click set_best_button for another answer' do
        before do
          within "#answer#{answer3.id}" do
            click_on I18n.t('.answers.set_best_button')
          end
        end

        scenario 'and marks answer as best' do
          expect(page).to have_content I18n.t('.answers.confirmations.mark_as_best')
          expect(page.find('.best_answer')).to have_text(answer3.body)
          expect(first('.answer')).to have_text(answer3.body)
        end
      end
    end
  end
end
