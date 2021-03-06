require 'rails_helper'

describe QuestionsController, :aggregate_failures do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns anew Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post(:create, params: {question: attributes_for(:question)}) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'saved question belongs_to signed user' do
        post :create, params: {question: attributes_for(:question)}
        expect(assigns(:question).user).to eq @user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post(:create, params: {question: attributes_for(:invalid_question)}) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post(:create, params: {question: attributes_for(:invalid_question)})
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let!(:question) { create(:question, title: 'MyString', body: 'MyText', user: @user) }

    context 'valid attributes' do
      it 'assings the requested question to @question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}, format: :js}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, params: {id: question, question: attributes_for(:question), format: :js}
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: {id: question, question: {title: 'new title', body: nil}}, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as authtorized owner' do
      sign_in_user
      let!(:question) { create(:question, user: @user) }

      it 'deletes question' do
        expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'as authtorized user' do
      sign_in_user
      let(:another_user) { create(:user) }
      let(:another_question) { create(:question, user: another_user) }

      it 'can`t deletes answer' do
        expect { delete :destroy, params: {id: another_question} }.to_not change(Answer, :count)
      end
    end

    context 'as non-authtorized user' do
      it 'can`t deletes answer' do
        expect { delete :destroy, params: {id: question} }.to_not change(Answer, :count)
      end
    end
  end
end
