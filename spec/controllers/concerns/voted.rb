require 'rails_helper'

shared_examples_for 'voted' do
  let(:model) { subject.class.controller_path.singularize.capitalize }
  let(:user)    { create(:user) }
  let(:question)    { create(:question, user: user) }
  let(:votable) do
    if model.to_s == 'Question'
      create(model.to_s.underscore.to_sym, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user, question: question)
    end
  end

  let(:params) do
    if model.to_s == 'Question'
      { id: votable.id }
    else
      { id: votable.id, question_id: question.id }
    end
  end

  describe 'PATCH #vote_up' do
    sign_in_user

    let(:vote_up) { post :vote_up, params: params }

    context 'as not the author' do
      it 'change vote count by +1' do
        expect { vote_up }.to change(votable.votes, :count).by(+1)
      end

      it 'render json' do
        vote_up
        expect(response_json).to eq({ rating: votable.evaluation, message: "Set vote_up", type: model.classify, id: votable.id })
      end
    end

    context 'as the author' do
      before do
        votable.update(user_id: @user.id)
      end

      it 'not change Vote count' do
        expect { vote_up }.to_not change(votable.votes, :count)
      end

      it 'render status 403' do
        vote_up
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PATCH #vote_down' do
    sign_in_user

    let(:vote_down) { post :vote_down, params: params }

    context 'as not the author' do
      it 'change vote count by +1' do
        expect { vote_down }.to change(votable.votes, :count).by(+1)
      end

      it 'render json' do
        vote_down
        expect(response_json).to eq({ rating: votable.evaluation, message: "Set vote_down", type: model.classify, id: votable.id })
      end
    end

    context 'as the author' do
      before do
        votable.update(user_id: @user.id)
      end

      it 'not change Vote count' do
        expect { vote_down }.to_not change(votable.votes, :count)
      end

      it 'render status 403' do
        vote_down
        expect(response.status).to eq 403
      end
    end
  end
end
