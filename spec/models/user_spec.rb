require 'rails_helper'

describe User do
  it { should have_many(:questions).inverse_of(:user).dependent(:destroy) }
  it { should have_many(:answers).inverse_of(:user).dependent(:destroy) }

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context 'author_of?' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }
    let(:first_question) { create(:question, user: first_user) }
    let(:second_question) { create(:question, user: second_user) }
    let(:answer) { create(:answer, question: first_question, user: first_user) }

    it { expect(first_user.author_of?(first_question)).to eq(true) }
    it { expect(first_user.author_of?(second_question)).to eq(false) }
    it { expect(first_user.author_of?(answer)).to eq(true) }
    it { expect(second_user.author_of?(answer)).to eq(false) }
  end
end
