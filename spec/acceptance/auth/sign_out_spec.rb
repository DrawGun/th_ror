require 'rails_helper'

feature 'User sign out', %q{
  As authtorized user
  I can sign out
} do

  given(:user) { create(:user) }

  scenario 'Authtorized user try to sign out' do
    sign_in(user)

    visit root_path
    click_on I18n.t('.devise.sessions.destroy.submit')

    expect(page).to have_content I18n.t('.devise.sessions.signed_out')
    expect(current_path).to eq root_path
  end
end
