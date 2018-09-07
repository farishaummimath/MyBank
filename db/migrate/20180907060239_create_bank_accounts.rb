class CreateBankAccounts < ActiveRecord::Migration
  def self.up
    create_table :bank_accounts do |t|
      t.integer :account_number
      t.references :customer
      t.integer :opening_balance
      t.boolean :active_status ,:null => false, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_accounts
  end
end
