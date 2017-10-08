class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy

  validates :title, :body, presence: true
end
