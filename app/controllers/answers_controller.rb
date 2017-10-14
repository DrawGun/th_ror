class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Your answer faild created. Try again.'
    end

    redirect_to question_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end
end
