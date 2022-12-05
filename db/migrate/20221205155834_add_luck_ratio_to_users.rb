class AddLuckRatioToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :luck_ratio, :float
  end
end
