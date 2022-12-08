class AddDailyRatioAndTrendToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :daily_ratio, :float
    add_column :users, :increasing_luck, :boolean, default: true
  end
end
