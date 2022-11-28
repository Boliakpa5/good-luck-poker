class AddNicknameAndBalanceToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nickname, :string
    add_column :users, :balance, :integer, default: 500
  end
end
