class PlayerHand < ApplicationRecord
  belongs_to :player
  belongs_to :table_hand
  validates :player_card1, :player_card2, presence: true, inclusion: { in: TableHand::CARDS }
end
