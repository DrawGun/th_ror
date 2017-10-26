require 'rails_helper'

describe User do
  it { should have_many(:questions).inverse_of(:user).dependent(:destroy) }
  it { should have_many(:answers).inverse_of(:user).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
