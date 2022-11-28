class CreateTableHands < ActiveRecord::Migration[7.0]
  def change
    create_table :table_hands do |t|
      t.references :poker_table, null: false, foreign_key: true
      t.string :table_card1
      t.string :table_card2
      t.string :table_card3
      t.string :table_card4
      t.string :table_card5
      t.integer :first_player_position
      t.integer :current_player_position
      t.string :status

      t.timestamps
    end
  end
end
