require_relative '../acceptance_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content I18n.t('.devise.sessions.signed_in')
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    sign_in

    expect(page).to have_content I18n.t('.devise.failure.invalid', authentication_keys: "Email")
    expect(current_path).to eq new_user_session_path
  end
end
