class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user, inverse_of: :questions

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments
end
