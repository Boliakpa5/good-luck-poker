class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, uniqueness: true, format: { with: /\A\w+\Z/ }, length: { in: 3..15 }
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_one_attached :photo
  has_many :players
  has_many :poker_tables, through: :players
  has_many :player_hands, through: :players
end
