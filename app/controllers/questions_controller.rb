class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = I18n.t('.questions.confirmations.created')
      redirect_to @question
    else
      flash[:alert] = I18n.t('.questions.failure.created')
      render :new
    end
  end

  def update
    if current_user.author_of?(@question) && @question.update(question_params)
      flash[:notice] = I18n.t('.questions.confirmations.updated')
    else
      flash[:alert] = I18n.t('.questions.failure.updated')
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = I18n.t('.questions.confirmations.deleted')
    else
      flash[:alert] = I18n.t('.questions.failure.deleted')
    end

    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
