class CreateBeneficiaries < ActiveRecord::Migration
  def self.up
    create_table :beneficiaries do |t|
      t.string :beneficiary_name
      t.references :from_bank_account
      t.references :to_bank_account
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :beneficiaries
  end
end
