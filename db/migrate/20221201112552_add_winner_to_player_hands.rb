class AddWinnerToPlayerHands < ActiveRecord::Migration[7.0]
  def change
    add_column :player_hands, :winner, :boolean, default: false
  end
end
