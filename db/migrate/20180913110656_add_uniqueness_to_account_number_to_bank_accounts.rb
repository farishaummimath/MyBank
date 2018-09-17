class AddUniquenessToAccountNumberToBankAccounts < ActiveRecord::Migration
  def self.up
    add_index :bank_accounts, :account_number, :unique => true
  end

  def self.down
    remove_index :bank_accounts, :account_number
  end
end
