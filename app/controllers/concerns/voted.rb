module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down]
    before_action :author_of?, only: [:vote_up, :vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { rating: @votable.evaluation, message: "Set vote_up", resource: resource, id: params[:id] }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { rating: @votable.evaluation, message: "Set vote_down", resource: resource, id: params[:id] }
  end

  private

  def resource
    params[:controller].singularize
  end

  def set_votable
    resource = params[:controller].capitalize.singularize.constantize
    @votable = resource.find_by(id: params[:id])
  end

  def author_of?
    head :forbidden if current_user.author_of?(@votable)
  end
end
