class PokerTable < ApplicationRecord
  has_many :players
  has_many :table_hands
  validates :name, :max_players, :small_blind, presence: true
  validates :max_players, numericality: { in: 5..9 }
  validates :small_blind, numericality: { only_integer: true, greater_than: 0 }
end
