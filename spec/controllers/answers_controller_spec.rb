require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let!(:answer_options) { {answer: attributes_for(:answer), question_id: question.id} }

      it 'saves the new answer in the database' do
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
        {answer: attributes_for(:invalid_answer), question_id: question.id}
      end

      it 'does not save the question' do
        expect { post(:create, params: invalid_answer_options) }.to_not change(Answer, :count)
      end

      it 'renders question view' do
        post(:create, params: invalid_answer_options)
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as authtorized user' do
      sign_in_user
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: {id: answer, question_id: question} }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index question view' do
        delete :destroy, params: {id: answer, question_id: question}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'as non-authtorized user' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes answer' do
        expect { delete :destroy, params: {id: answer, question_id: question} }.to_not change(Answer, :count)
      end
    end
  end
end
