class AddAccountNumberToBankAccounts < ActiveRecord::Migration
  def self.up
    change_column :bank_accounts, :account_number, :integer, :limit => 8
  end

  def self.down
    change_column :bank_accounts, :account_number
  end
end
