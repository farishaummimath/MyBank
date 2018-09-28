class Customer < ActiveRecord::Base
  has_one :user, :as => :record, :dependent => :destroy
  has_one :bank_account, :dependent => :destroy
  cattr_reader :per_page
   @@per_page = 10
  validates_presence_of :first_name ,:last_name, :date_of_birth, :nationality,
    :address, :contact_number, :photo
   EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_numericality_of :contact_number, :only_integer => true
  validates_format_of	  :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  has_attached_file :photo,
    :styles => {:medium => "120x120>", :thumb => "20x20>"},
					   :default_url =>'/images/noimage.png'

	validates_attachment_content_type :photo, 
    :content_type => ['image/jpeg','image/png']
  has_attached_file :signature, 
    :styles => {:medium => "120x60>"}
	validates_attachment_content_type :signature, 
    :content_type => ['image/jpeg','image/png']
  named_scope :search_application, lambda{|acc| {:conditions => ["application_number = ?","#{acc}"]}}

  before_update :update_user
  before_create :add_user

  def add_user
    user = User.add(self.first_name, self.last_name,nil)
    self.user = user unless user.new_record?
  end
  
  def update_user
    user.set_fields(self.first_name, self.last_name) 
  end
    
  def self.create_account(customer_id,user)
    if customer_id && user
     unique_number =15.times.map { (0..9).to_a.choice }.join
     num = unique_number.to_i
     bank_account = BankAccount.new(:customer_id => customer_id,
       :account_number => num,:opening_balance => 0, :current_balance => 0)
      if bank_account.save 
        if user.update_attributes(:is_active => true)  
          return bank_account
        else
          return nil
        end
      end
    end
  end
 
end