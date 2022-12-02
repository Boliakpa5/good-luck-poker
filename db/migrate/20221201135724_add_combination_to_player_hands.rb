class AddCombinationToPlayerHands < ActiveRecord::Migration[7.0]
  def change
    add_column :player_hands, :combination, :integer, array: true
  end
end
