class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', inverse_of: :resolved_question, foreign_key: :best_answer_id, optional: true
  belongs_to :user, inverse_of: :questions

  validates :title, :body, presence: true
end
