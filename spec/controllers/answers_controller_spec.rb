require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let!(:answer_options) { {answer: attributes_for(:answer, question_id: question.id), question_id: question.id} }

      it 'saves the new question in the database' do
        expect {
          post(:create, params: answer_options)
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: answer_options
        expect(response).to redirect_to question_path(question)
      end

      it 'saved answer belongs_to question' do
        post :create, params: answer_options
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      let!(:invalid_answer_options) do
        {answer: attributes_for(:invalid_answer, question_id: question.id), question_id: question.id}
      end

      it 'does not save the question' do
        expect { post(:create, params: invalid_answer_options) }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post(:create, params: invalid_answer_options)
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
