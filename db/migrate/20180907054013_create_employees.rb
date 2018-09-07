class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.string :nationality
      t.string :address
      t.string :email
      t.integer :contact_number

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
