class AddCurrentBalanceToBankAccounts < ActiveRecord::Migration
  def self.up
    add_column :bank_accounts, :current_balance, :integer, :default => 0
  end

  def self.down
    remove_column :bank_accounts, :current_balance
  end
end
