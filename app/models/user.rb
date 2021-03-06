require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  belongs_to :record, :polymorphic => true
  cattr_reader :per_page
   @@per_page = 10
  attr_accessible :password , :is_admin, :is_active

  validates_presence_of :username #,:password
  before_update :encrypt_password
  before_create :encrypt_password
  validate :check_password
  
  def role_symbols
    symbols = []
    if self.record_type.downcase == 'employee' && self.is_admin == true
      symbols = [:admin]
    elsif self.record_type.downcase == 'employee' && self.is_admin == false   
      symbols= [:employee]
    elsif self.record_type.downcase == 'customer' && self.is_admin == false
      symbols= [:customer]
    else
        return nil
    end 
    return symbols
  end
  def check_password
    errors.add(:password, :blank) if self.new_record? and !self.password.present?
  end
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)  
  end
  
  def self.authenticate(login_cred)
    
  	user = find_by_username(login_cred[:username])
    if login_cred[:password].present?
      if (user) && (user.has_password?(login_cred[:password]))
        return user
      else
        return nil
      end  
    else
        return nil
    end
      
  end
  def self.add(first_name,last_name,manager)
    user = User.new
    user.set_fields(first_name,last_name)
    if manager
      if self.manager == "1"
        user.is_admin = true
      end 
    end  
    user.save    
    return user
  end    
    
  def set_fields(fname,lname)
      self.username = fname.downcase + lname.downcase
      self.password = fname.downcase + lname.downcase+"123"
      self.save
  end  
 
  private   
  
  def encrypt_password
    self.salt = make_salt  if new_record?
    self.encrypted_password = encrypt(password)

  end

  def encrypt(string)
  secure_hash("#{salt}#{string}") # temp implementation
  end

  def make_salt
  secure_hash("#{Time.now.utc}#{password}")
  end

  def secure_hash(string)
  Digest::SHA2.hexdigest(string)
end
end