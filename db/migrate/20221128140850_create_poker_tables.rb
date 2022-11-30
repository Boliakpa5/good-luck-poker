class CreatePokerTables < ActiveRecord::Migration[7.0]
  def change
    create_table :poker_tables do |t|
      t.string :name
      t.integer :max_players
      t.integer :small_blind

      t.timestamps
    end
  end
end
