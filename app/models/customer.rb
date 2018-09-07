class Customer < ActiveRecord::Base
  has_one :user, :as => :record
  has_many :bank_accounts
  
  validates_presence_of :first_name ,:last_name, :date_of_birth, :nationality, :address, :contact_number
end
