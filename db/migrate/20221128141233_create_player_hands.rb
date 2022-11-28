class CreatePlayerHands < ActiveRecord::Migration[7.0]
  def change
    create_table :player_hands do |t|
      t.string :player_card1
      t.string :player_card2
      t.references :player, null: false, foreign_key: true
      t.references :table_hand, null: false, foreign_key: true
      t.integer :bet_amount, default: 0
      t.boolean :folded, default: false

      t.timestamps
    end
  end
end
