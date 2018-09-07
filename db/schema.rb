# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20180907063415) do

  create_table "bank_accounts", :force => true do |t|
    t.integer  "account_number"
    t.integer  "customer_id"
    t.integer  "opening_balance"
    t.boolean  "active_status",   :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_transactions", :force => true do |t|
    t.integer  "bank_account_id"
    t.string   "particulars"
    t.string   "transaction_type"
    t.integer  "transaction_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "nationality"
    t.string   "address"
    t.string   "email"
    t.integer  "contact_number"
    t.string   "local_ref_full_name"
    t.string   "local_ref_contact_number"
    t.string   "local_ref_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "signature_file_name"
    t.string   "signature_content_type"
    t.integer  "signature_file_size"
    t.datetime "signature_updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "nationality"
    t.string   "address"
    t.string   "email"
    t.integer  "contact_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "record_id"
    t.string   "record_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
