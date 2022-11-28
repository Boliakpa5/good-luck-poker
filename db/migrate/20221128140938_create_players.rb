class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.references :poker_table, null: false, foreign_key: true
      t.integer :stack
      t.integer :position
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
