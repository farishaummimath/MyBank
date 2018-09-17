class BankAccount < ActiveRecord::Base
  belongs_to :customer
  has_many :bank_transactions
  has_one :closure_request
  has_many :beneficiaries, :foreign_key => 'from_bank_account_id'
  has_many :beneficiary_accounts, :through => :beneficiaries, :source => :to_bank_account
  attr_accessible :account_number,:current_balance
  
  
  def self.search_account(name,nationality,acc_num)
    if name && nationality && acc_num
      where('customer.first_name LIKE ? AND customer.nationality = ? AND customer.bank_account.account_number = ? ', "%#{name}%","#{nationality}","#{acc_num}")
    end
    
    
  end
  def self.search(account_number)
    if account_number
      find_by_account_number(account_number)
    else
      return nil
    end
  end
  def self.withdraw(amount,ba_id)
    bank_account = BankAccount.find_by_id(ba_id)
    curr=bank_account.current_balance
    if(bank_account.current_balance >= amount.to_i)
      bank_account.update_attributes(:current_balance =>curr-amount.to_i)
      tran = BankTransaction.new
      tran.bank_account_id = bank_account.id
      tran.transaction_type = "Dr"
      tran.transaction_amount = amount.to_i 
      tran.balance = bank_account.current_balance     
      tran.particulars = "withdrawal of #{tran.transaction_amount} from BANK"  

      tran.save 
    else
      raise "Available balance low"
    end  
    return tran     
    
  end
  def self.deposit(amount,ba_id)
    bank_account = BankAccount.find_by_id(ba_id)
    curr=bank_account.current_balance
    bank_account.update_attributes(:current_balance =>curr+amount.to_i)
    tran = BankTransaction.new
    tran.bank_account_id = bank_account.id
    tran.transaction_type = "Cr"
    tran.transaction_amount = amount.to_i  
    tran.particulars = "Deposited #{tran.transaction_amount} from BANK"  
    tran.balance = bank_account.current_balance 
    tran.save  

    return tran
  end
  def self.transfer(from_id,to_id,amount)
   
   w = withdraw(amount,from_id)
    
   d = deposit(amount,to_id) 
   
   w.particulars  ="deposited to XXXXX#{d.bank_account.customer.first_name}"
   w.save
   d.particulars ="Transferred from XXXX#{w.bank_account.customer.first_name}"
   d.save
 
  end
  
  def account_closure
    
  end
  
  def account_suspend
    
  end

end
