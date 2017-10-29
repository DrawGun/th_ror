require 'rails_helper'

feature 'User registrations', %q{
  In order to be able to ask question
  As an user
  I want to be able to registrations
} do

  given(:user) { build(:user) }

  scenario 'Registered user try to registrations with valid params' do
    sign_up('test@test.ru', 123456)

    expect(page).to have_content I18n.t('.devise.registrations.signed_up')
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to registrations with invalid params' do
    sign_up

    expect(page).to have_content I18n.t('.errors.messages.not_saved.other', count: 2, resource: 'user')
    expect(current_path).to eq user_registration_path
  end
end
