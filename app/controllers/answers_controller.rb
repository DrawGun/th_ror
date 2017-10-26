class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:create, :destroy]
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user, question: @question))

    if @answer.save
      flash[:notice] = I18n.t('.answers.confirmations.confirmed')
      redirect_to question_path(@question)
    else
      flash[:notice] = 'Your answer faild created. Try again.'
      render 'questions/show'
    end
  end

  def destroy
    if current_user == @answer.user
      @answer.destroy
      flash[:notice] = I18n.t('.answers.confirmations.deleted')
    else
      flash[:notice] = I18n.t('.answers.failure.deleted')
    end

    redirect_to question_path(@question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
