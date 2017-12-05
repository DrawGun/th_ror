require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model)   { described_class }
  let(:user)    { create(:user) }
  let(:question)    { create(:question, user: user) }
  let(:votable) do
    if model.to_s == 'Question'
      create(model.to_s.underscore.to_sym, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user, question: question)
    end
  end

  describe '#vote_up' do
    it 'create new vote with value = 1' do
      expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq 1
    end
  end

  describe '#vote_down' do
    it 'create new vote with value = -1' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.value).to eq(-1)
    end
  end

  describe '#sum_value' do
    it 'return sum all the vote :value' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.evaluation).to eq -1
    end
  end
end
