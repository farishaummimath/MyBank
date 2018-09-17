class AddApplicationNumberToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :application_number, :string, :unique => true
  end

  def self.down
    remove_column :customers, :application_number
  end
end
