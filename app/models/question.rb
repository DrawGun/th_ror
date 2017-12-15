class Question < ApplicationRecord
  include Attachable
  include Authorable
  include Votable

  has_many :answers, inverse_of: :question, dependent: :destroy

  validates :title, :body, presence: true
end
