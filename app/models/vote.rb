class Vote < ApplicationRecord
  include Authorable

  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :value, inclusion: { in: [-1, 1] }
  validates :user_id,
            uniqueness: { scope: [:votable_type, :votable_id], message: 'You have already voted' }

  def unvote?(value)
    persisted? && self.value == value
  end
end
