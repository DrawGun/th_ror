require_relative '../acceptance_helper'

feature 'Voting for answer', %q{
  In order to express my opinion about answer
  As an authenticated user
  I want to be able to like or dislike any answer (except my own)
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'Unauthenticated user can`t like or unlike answer', js: true do
    visit question_path(question)
    within("#answer#{answer.id}") do
      expect(page).to_not have_selector('.vote-up')
      expect(page).to_not have_selector('.vote-down')
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can seen voited links' do
      within("#answer#{answer2.id}") do
        expect(page).to have_selector('.vote-up')
        expect(page).to have_selector('.vote-down')
      end
    end

    scenario 'like as author can`t like or unlike answer' do
      within("#answer#{answer.id}") do
        expect(page).to_not have_selector('.vote-up')
        expect(page).to_not have_selector('.vote-down')
      end
    end

    scenario 'like as visitor set and change answer', js: true do

      within("#answer#{answer2.id}") do
        expect(find('.vote-count').value).to eq '0'
      end
      within("#answer#{answer2.id}") do
        puts find('.vote-count').value
        find('.vote-up').click
        save_and_open_page
        puts answer2.reload.votes.sum(:value)
        puts find('.vote-count').value
        sleep 10
        expect(find('.vote-count').value).to eq '1'

        # eventually do
        #   # binding.pry
        #   puts find('.vote-count').value
        #   expect(find('.vote-count').value).to eq '1'
        # end
      end
      # within("#answer#{answer2.id}") do
      #   find('.vote-up').click
      #   eventually do
      #     expect(find('.vote-count').value).to eq '0'
      #   end
      # end
      # within("#answer#{answer2.id}") do
      #   find('.vote-down').click
      #   eventually do
      #     expect(find('.vote-count').value).to eq '-1'
      #   end
      # end
      # within("#answer#{answer2.id}") do
      #   find('.vote-down').click
      #   eventually do
      #     expect(find('.vote-count').value).to eq '0'
      #   end
      # end
    end
  end
end
