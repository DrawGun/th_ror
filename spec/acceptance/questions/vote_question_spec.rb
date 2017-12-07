require_relative '../acceptance_helper'

feature 'Voting for question', %q{
  In order to express my opinion about question
  As an authenticated user
  I want to be able to like or dislike any question (except my own)
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'Unauthenticated user can`t like or unlike answer', js: true do
    visit question_path(question)
    within("#question-info") do
      expect(page).to_not have_selector('.vote-up')
      expect(page).to_not have_selector('.vote-down')
    end
  end

  describe 'Authenticated user like as author', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can`t like or unlike answer' do
      within("#question-info") do
        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
      end
    end
  end

  describe 'Authenticated user like as visitor', js: true do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'can seen voited links' do
      within("#question-info") do
        expect(page).to have_selector('.vote-up')
        expect(page).to have_selector('.vote-down')
      end
    end


  end

  scenario 'set and change answer', js: true do
    sign_in(user2)
    visit question_path(question)

    within("#question-info") do
      expect(find('.vote-count').value).to eq '0'
    end

    within("#question-info") do
      find('.vote-up').click

      eventually do
        expect(find('.vote-count').value).to eq '1'
      end
    end
  end
end
