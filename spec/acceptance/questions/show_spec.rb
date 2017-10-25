require 'rails_helper'

feature 'Show question', %q{
  User in question page can
  I want to be able to see questions list
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }


  scenario 'Authenticated user can see question and answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end

  scenario 'Non-authenticated user can see question and answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer1.body
    expect(page).to have_content answer2.body
  end
end
