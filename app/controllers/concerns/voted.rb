module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
    before_action :author_of?, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    # binding.pry
    render json: { rating: @votable.evaluation, message: "Set vote_up", type: @votable.class.to_s, id: @votable.id }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { rating: @votable.evaluation, message: "Set vote_down", type: @votable.class.to_s, id: @votable.id }
  end

  private

  def set_votable
    @votable = if params[:controller] == 'questions'
      Question.find(params[:id])
    else
      Answer.find(params[:id])
    end
  end

  def author_of?
    head :forbidden if current_user.author_of?(@votable)
  end
end
