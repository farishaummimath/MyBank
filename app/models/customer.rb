class Customer < ActiveRecord::Base
  has_one :user, :as => :record, :dependent => :destroy
  has_one :bank_account
  attr_accessible :first_name ,:application_status, :application_number,
    :last_name, :date_of_birth, :nationality, :address, :contact_number, :photo
  validates_presence_of :first_name ,:last_name, :date_of_birth, :nationality,
    :address, :contact_number, :photo
  has_attached_file :photo,
    :styles => {:medium => "120x120>", :thumb => "20x20>"},
					   :default_url =>'/images/missing_thumb.png'

	validates_attachment_content_type :photo, 
    :content_type => ['image/jpeg','image/png']
  has_attached_file :signature, 
    :styles => {:medium => "120x60>"}
	validates_attachment_content_type :signature, 
    :content_type => ['image/jpeg','image/png']
  
  before_update :update_user

  before_create :add_user

  def add_user
    user = User.new
    user.username = self.first_name.downcase + self.last_name.downcase
    user.password = self.first_name.downcase + self.last_name.downcase+"123"
    user.save
    self.user = user unless user.new_record? 
  end
  
  def update_user
    user.username = self.first_name.downcase + self.last_name.downcase
    user.password = self.first_name.downcase + self.last_name.downcase+"123"
    user.save
    
  end
  def self.search(search)
    if search
      find(:all, :conditions => ['application_number = ?', "#{search}"])
    else
      return nil
    end
  end
  
  def self.create_account(customer_id)
    if customer_id
     bank_account = BankAccount.new
     bank_account.customer_id = customer_id
     unique_number =15.times.map { (0..9).to_a.choice }.join
     num = unique_number.to_i
     bank_account.account_number = num
     bank_account.opening_balance = 0
     bank_account.save 
     user = User.find_by_record_id_and_record_type(customer_id,"Customer")
     user.is_active = true
     user.save

     
    else
      return nil
    end
  end
 end
