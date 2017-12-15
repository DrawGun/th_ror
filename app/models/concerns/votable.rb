module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def evaluation
    votes.sum(:value)
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  private

  def vote(user, value)
    vote = votes.find_or_initialize_by(user_id: user.id)

    if vote.unvote?(value)
      vote.destroy
    else
      vote.update(value: value)
    end
  end
end
