class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true

  after_commit :reset_best, if: -> (answer) { answer.previous_changes.include?(:best) }

  scope :best, -> { where(best: true) }

  private

  def reset_best
    question.answers.best.where.not(id: id).update_all(best: false)
  end
end
