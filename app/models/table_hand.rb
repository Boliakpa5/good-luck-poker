class TableHand < ApplicationRecord
  CARDS = %w[2H 3H 4H 5H 6H 7H 8H 9H TH JH QH KH AH
             2S 3S 4S 5S 6S 7S 8S 9S TS JS QS KS AS
             2D 3D 4D 5D 6D 7D 8D 9D TD JD QD KD AD
             2C 3C 4C 5C 6C 7C 8C 9C TC JC QC KC AC].freeze
  STATUSES = %w[winner preflop flop turn river end]
  belongs_to :poker_table
  has_many :player_hands
  has_many :players, through: :player_hands
  validates :table_card1, :table_card2, :table_card3, :table_card4, :table_card5, inclusion: { in: CARDS }, allow_nil: true
  validates :status, inclusion: { in: STATUSES }
end
