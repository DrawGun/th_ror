require 'rails_helper'

describe Answer do
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to(:question).inverse_of(:answers) }
  it { should belong_to(:user).inverse_of(:answers) }
  it { should validate_presence_of(:body) }
  it { should accept_nested_attributes_for :attachments }

  context 'set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }
    let!(:answer3) { create(:answer, question: question, user: user) }

    before do
      answer1.set_best
    end

    it { expect(answer1.reload.best).to be true }
    it { expect(answer2.reload.best).to be false }

    it 'set_best again' do
      answer1.set_best
      expect(answer1.reload.best).to be true
    end
  end
end
