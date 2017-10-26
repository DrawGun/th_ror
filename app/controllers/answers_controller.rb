class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:create, :destroy]
  before_action :set_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = I18n.t('.answers.confirmations.confirmed')
    else
      flash[:notice] = 'Your answer faild created. Try again.'
    end

    redirect_to question_path(@question)
  end

  def destroy
    @answer.destroy
    flash[:notice] = I18n.t('.answers.confirmations.deleted')
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
    params.require(:answer).permit(:body).merge(question: @question)
  end
end
