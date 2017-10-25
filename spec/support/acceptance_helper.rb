module AcceptanceHelper
  def sign_in(user = OpenStruct.new(email: 'wrongtest@example.com', password: 'wrongtest123456789'))
    visit new_user_session_path

    within('form#new_user') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on I18n.t('.devise.sessions.new.submit')
    end
  end

  def sign_up(email = nil, password = nil)
    visit new_user_registration_path

    within('form#new_user') do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_on I18n.t('.devise.registrations.new.submit')
    end
  end
end
