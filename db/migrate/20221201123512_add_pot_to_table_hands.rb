class AddPotToTableHands < ActiveRecord::Migration[7.0]
  def change
    add_column :table_hands, :pot, :integer, default: 0
  end
end
