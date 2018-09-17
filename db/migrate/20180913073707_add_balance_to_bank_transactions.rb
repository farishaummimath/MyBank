class AddBalanceToBankTransactions < ActiveRecord::Migration
  def self.up
    add_column :bank_transactions, :balance, :integer, :null => false
  end

  def self.down
    remove_column :bank_transactions, :balance
  end
end
