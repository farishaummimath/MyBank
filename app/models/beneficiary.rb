class Beneficiary < ActiveRecord::Base
  belongs_to :to_bank_account, :class_name => 'BankAccount'
  belongs_to :from_bank_account, :class_name => 'BankAccount'
  validates_presence_of :beneficiary_name , :from_bank_account, :to_bank_account
end
