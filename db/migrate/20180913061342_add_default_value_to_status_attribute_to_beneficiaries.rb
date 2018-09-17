class AddDefaultValueToStatusAttributeToBeneficiaries < ActiveRecord::Migration
  def self.up
    change_column :beneficiaries, :status, :string, :default => "pending"
  end

  def self.down
    change_column :beneficiaries, :status, :string, nil

  end
end
