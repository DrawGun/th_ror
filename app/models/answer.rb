class Answer < ApplicationRecord
  include Attachable
  include Authorable
  include Votable

  belongs_to :question, inverse_of: :answers

  validates :body, presence: true

  scope :best, -> { where(best: true) }

  def set_best
    transaction do
      question.answers.best.where.not(id: id).update_all(best: false)
      update!(best: true)
    end
  end
end
