class Player < ApplicationRecord
  belongs_to :user
  belongs_to :poker_table
  has_many :player_hands
  has_many :table_hands, through: :player_hands
  validates :stack, :position, presence: true
  validates :position, numericality: { in: 1..9 } #, uniqueness: { scope: [:poker_table, where(active: true)] }
  # Pour utiliser un .active partout
  scope :active, -> { where(active: true) }
end
