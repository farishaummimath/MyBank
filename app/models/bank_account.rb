class BankAccount < ActiveRecord::Base
  belongs_to :customer
  has_many :bank_transactions
  has_one :closure_request
  has_many :beneficiaries, :foreign_key => 'from_bank_account_id'
  has_many :beneficiary_accounts, :through => :beneficiaries, :source => :to_bank_account
  #attr_accessible :account_number,:current_balance
  named_scope :search_name, lambda{|name| {:joins => :customer,:conditions => ["customers.first_name LIKE ?", "%#{name}%"]}}
  named_scope :search_nationality, lambda{|nat| {:joins => :customer,:conditions => ["customers.nationality = ?",nat]}}
  named_scope :search_account_number, lambda{|acc| {:conditions => ["account_number = ?","#{acc}"]}}
  
  
  def self.search_acc(account_number)
    if account_number
      find_by_account_number(account_number)
    else
      return nil
    end
  end
  
  def self.search(a,b,c)
    if a.present? || b.present? || c.present?
      puts b.present?
      x = self
      x = x.search_name(a) if a.present?
      x = x.search_nationality(b) if b.present?
      x = x.search_account_number(c) if c.present?
      return x
    else
      return nil
    end  
  end

  def self.withdraw(amount,ba_id)    
    ActiveRecord::Base.transaction do
      f = 0
      if amount.present? && amount.to_i != 0
       @bank_account = BankAccount.find_by_id(ba_id)
       curr=@bank_account.current_balance
        if(@bank_account.current_balance >= amount.to_i)
          if @bank_account.update_attributes(:current_balance => curr - amount.to_i)
            @tran = BankTransaction.new(
              :bank_account_id => @bank_account.id ,
              :transaction_type => "Dr",
              :transaction_amount => amount.to_i,
              :particulars =>"Withdrawal #{amount} from BANK",
              :balance => @bank_account.current_balance) 
            if @tran.save
              f = 1
            end 
          end      
        end                 
      end
      if f == 0
        raise ActiveRecord::Rollback 
      else
        return @tran
      end 
  end
   
 end  
  
  def self.deposit(amount,ba_id)
    @bank_account = BankAccount.find_by_id(ba_id)
    curr= @bank_account.current_balance
    f= 0
    ActiveRecord::Base.transaction do
      if amount.present? && amount.to_i != 0
        if @bank_account.update_attributes(:current_balance => curr + amount.to_i)    
          @tran = BankTransaction.new(:bank_account_id => @bank_account.id ,
          :transaction_type => "Cr",
          :transaction_amount => amount.to_i,
          :particulars =>"Deposited #{amount} from BANK",:balance => @bank_account.current_balance) 
          if @tran.save
            f = 1
          end          
        end   
      end 
       if f == 0
        raise ActiveRecord::Rollback 
      else
        return @tran
      end
    end  
  end 
  
  def self.transfer(from_id,to_id,amount)
    f = 0
    ActiveRecord::Base.transaction do 
      to_account = find(to_id)
      if (amount.to_i<= to_account.current_balance)
        w = withdraw(amount,from_id)
        d = deposit(amount,to_id)    
            
        if w && d
          if w.update_attributes(:particulars => 
                "deposited to XXXXX#{d.bank_account.customer.first_name}") &&
              d.update_attributes(:particulars => 
              "Transferred from XXXX#{w.bank_account.customer.first_name}")
              f = 1          
          end
        end  
      end  
      if f == 0
        raise ActiveRecord::Rollback 
      else
        return @tran
      end
      
      end
  end
  
end
