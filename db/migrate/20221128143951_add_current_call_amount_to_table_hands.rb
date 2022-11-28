class AddCurrentCallAmountToTableHands < ActiveRecord::Migration[7.0]
  def change
    add_column :table_hands, :current_call_amount, :integer
  end
end
