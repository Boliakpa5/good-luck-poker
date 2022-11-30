class AddPositionsToTableHands < ActiveRecord::Migration[7.0]
  def change
    add_column :table_hands, :positions, :integer, array: true
  end
end
