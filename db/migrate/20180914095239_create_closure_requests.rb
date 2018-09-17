class CreateClosureRequests < ActiveRecord::Migration
  def self.up
    create_table :closure_requests do |t|
      t.references :bank_account
      t.string :reason
      t.string :approval_status ,:default =>"pending"

      t.timestamps
    end
  end

  def self.down
    drop_table :closure_requests
  end
end
