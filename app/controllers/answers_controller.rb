class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: :create
  before_action :set_answer, only: [:destroy, :update]

  include Voted

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))

    if @answer.save
      flash[:notice] = I18n.t('.answers.confirmations.created')
    else
      flash[:alert] = I18n.t('.answers.failure.created')
    end
  end

  def update
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      @question = @answer.question
      flash[:notice] = I18n.t('.answers.confirmations.updated')
    else
      flash[:alert] = I18n.t('.answers.failure.updated')
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = I18n.t('.answers.confirmations.deleted')
    else
      flash[:alert] = I18n.t('.answers.failure.deleted')
    end
  end

  def mark_as_best
    @answer = Answer.find(params[:answer_id])
    if current_user.author_of?(@answer) && @answer.set_best
      @question = @answer.question
      flash[:notice] = I18n.t('.answers.confirmations.mark_as_best')
    else
      flash[:alert] = I18n.t('.answers.failure.mark_as_best')
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
