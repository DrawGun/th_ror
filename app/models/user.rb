class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, inverse_of: :user, dependent: :destroy
  has_many :answers, inverse_of: :user, dependent: :destroy

  def author_of?(user_id)
    id == user_id
  end
end
