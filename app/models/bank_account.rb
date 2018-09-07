class BankAccount < ActiveRecord::Base
  belongs_to :customer
  has_many :bank_transactions
end
