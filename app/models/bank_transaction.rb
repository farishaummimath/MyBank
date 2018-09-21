class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account 
  validates_presence_of :transaction_amount,:transaction_type,:bank_account_id
  validates_numericality_of :transaction_amount, :only_integer => true  
end
