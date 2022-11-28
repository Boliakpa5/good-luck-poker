class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, uniqueness: true
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_one_attached :photo
end
