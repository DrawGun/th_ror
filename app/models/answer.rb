class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true

  before_save :reset_best, if: 'best_changed? && best'

  scope :best, -> { where(best: true) }

  private

  def reset_best
    question.answers.best.update_all(best: false)
  end
end
