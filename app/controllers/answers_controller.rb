class AnswersController < ApplicationController
  before_action :set_question, only: :create

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Your answer faild created. Try again.'
    end

    redirect_to question_path(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(question: @question)
  end
end
