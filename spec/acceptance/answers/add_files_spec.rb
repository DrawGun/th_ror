require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    within('#create_answer') do
      fill_in 'new_answer_body', with: 'My answer'
      click_on 'Add Attachment'
      page.all('input[type="file"]')[0].set(Rails.root.join('spec', 'spec_helper.rb'))
      click_on 'Add Attachment'
      page.all('input[type="file"]')[1].set(Rails.root.join('spec', 'rails_helper.rb'))
      click_on I18n.t('.answers.new.submit')
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
