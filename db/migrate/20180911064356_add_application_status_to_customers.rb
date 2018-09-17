class AddApplicationStatusToCustomers < ActiveRecord::Migration
  def self.up
    add_column :customers, :application_status, :string ,:default => "pending"
  end

  def self.down
    remove_column :customers, :application_status
  end
end
