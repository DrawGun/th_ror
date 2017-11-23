require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Body', with: 'Test question'
    fill_in 'Title', with: 'text text text'
    click_on 'Add Attachment'
    page.all('input[type="file"]')[0].set(Rails.root.join('spec', 'spec_helper.rb'))
    click_on 'Add Attachment'
    page.all('input[type="file"]')[1].set(Rails.root.join('spec', 'rails_helper.rb'))
    click_on I18n.t('.answers.new.submit')

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
