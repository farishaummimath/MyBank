class CreateBankTransactions < ActiveRecord::Migration
  def self.up
    create_table :bank_transactions do |t|
      t.references :bank_account
      t.string :particulars
      t.string :transaction_type
      t.integer :transaction_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :bank_transactions
  end
end
