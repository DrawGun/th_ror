class Answer < ApplicationRecord
  validates :title, :body, :question_id, presence: true

  belongs_to :question, inverse_of: :answers
end
