class BankTransaction < ActiveRecord::Base
  belongs_to :bank_account
  
  attr_accessible :balance
  
  
  
end
