require 'rails_helper'

describe AnswersController do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let!(:answer_options) { {answer: attributes_for(:answer), question_id: question.id, format: :js} }

      it 'saves the new answer in the database' do
        expect {
          post(:create, params: answer_options)
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: answer_options
        expect(response).to render_template :create
      end

      it 'saved answer belongs_to question' do
        post :create, params: answer_options
        expect(assigns(:answer).question).to eq question
      end

      it 'saved answer belongs_to question v2' do
        expect { post :create, params: answer_options }.to change(question.answers, :count).by(1)
      end

      it 'saved answer belongs_to signed user' do
        post :create, params: answer_options
        expect(assigns(:answer).user).to eq @user
      end
    end

    context 'with invalid attributes' do
      let!(:invalid_answer_options) do
        {answer: attributes_for(:invalid_answer), question_id: question.id, format: :js}
      end

      it 'does not save the question' do
        expect { post(:create, params: invalid_answer_options) }.to_not change(Answer, :count)
      end

      it 'renders question view' do
        post(:create, params: invalid_answer_options)
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #mark_as_best' do
    context 'as authtorized user' do
      sign_in_user
      let(:answer) { create(:answer, question: question, user: @user) }
      let(:options) { {answer_id: answer.id, question_id: question.id, format: :js} }

      it 'set best answer to question' do
        post :mark_as_best, params: options
        expect(question.reload.best_answer).to eq answer
      end

      it 'set another best answer to question' do
        answer2 = create(:answer, question: question, user: @user)
        question.update(best_answer_id: answer2.id)
        expect(question.reload.best_answer).to eq answer2

        post :mark_as_best, params: options
        expect(question.reload.best_answer).to eq answer
      end

      it 'can`t set if not owner of question' do
        user2 = create(:user)
        question2 = create(:question, user: user2)
        answer2 = create(:answer, question: question2, user: user2)
        options = {answer_id: answer2.id, question_id: question2.id, format: :js}

        post :mark_as_best, params: options
        expect(question.reload.best_answer).to eq nil
      end
    end

    context 'as non-authtorized user' do
      let(:user) { create(:user) }
      let(:answer) { create(:answer, question: question, user: user) }
      let(:options) { {answer_id: answer.id, question_id: question.id} }

      it 'can`t set best answer' do
        expect(question.best_answer).to eq nil
        post :mark_as_best, params: options
        expect(question.reload.best_answer).to eq nil
      end

      it 'can`t set another best answer to question' do
        answer2 = create(:answer, question: question, user: user)
        question.update(best_answer_id: answer2.id)
        expect(question.reload.best_answer).to eq answer2

        post :mark_as_best, params: options
        expect(question.reload.best_answer).to eq answer2
      end
    end
  end

  describe 'PATCH #update' do
    context 'as authtorized owner' do
      sign_in_user
      let!(:answer) { create(:answer, question: question, user: @user) }
      let(:new_answer_body) { 'New text' }

      context 'with valid attributes' do
        let!(:answer_options) { {id: answer.id, answer: {body: new_answer_body}, question_id: question.id, format: :js} }

        before do
          patch :update, params: answer_options, format: :js
        end

        it 'updates answer attributes' do
          answer.reload
          expect(answer.body).to eq new_answer_body
        end

        it 'assings the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'assings the question' do
          expect(assigns(:question)).to eq question
        end

        it 'render update template' do
          expect(response).to render_template :update
        end
      end

      context 'try to update other answer' do
        let(:another_user) { create(:user) }
        let(:another_answer) { create(:answer, question: question, user: another_user) }
        let!(:answer_options) { {id: another_answer.id, answer: {body: new_answer_body}, question_id: question.id, format: :js} }

        before do
          patch :update, params: answer_options, format: :js
        end

        it 'but can`t do this' do
          answer.reload
          expect(answer.body).to_not eq new_answer_body
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as authtorized owner' do
      sign_in_user
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: {id: answer, question_id: question, format: :js} }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index question view' do
        delete :destroy, params: {id: answer, question_id: question, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'as authtorized user' do
      sign_in_user
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'can`t deletes answer' do
        expect { delete :destroy, params: {id: answer, question_id: question, format: :js} }.to_not change(Answer, :count)
      end
    end

    context 'as non-authtorized user' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'can`t deletes answer' do
        expect { delete :destroy, params: {id: answer, question_id: question, format: :js} }.to_not change(Answer, :count)
      end
    end
  end
end
