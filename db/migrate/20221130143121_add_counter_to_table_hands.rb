class AddCounterToTableHands < ActiveRecord::Migration[7.0]
  def change
    add_column :table_hands, :counter, :integer, default: 0
  end
end
