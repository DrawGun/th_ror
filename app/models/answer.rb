class Answer < ApplicationRecord
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  scope :best, -> { where(best: true) }

  def set_best
    transaction do
      self.question.answers.best.where.not(id: id).update_all(best: false)
      self.update!(best: true)
    end
  end
end
