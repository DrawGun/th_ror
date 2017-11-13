class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  has_one :resolved_question, class_name: 'Question', inverse_of: :best_answer, foreign_key: :best_answer_id
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true
end
