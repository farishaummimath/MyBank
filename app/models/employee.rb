class Employee < ActiveRecord::Base
  has_one :user, :as => :record, :dependent => :destroy
  attr_accessor :manager
  attr_accessible :manager,:first_name ,:last_name,:middle_name,:email,:nationality, :date_of_birth, :address, :contact_number
  validates_presence_of :first_name ,:last_name, :date_of_birth, :address, :contact_number
  has_attached_file :photo, :styles => {:medium => "120x120>", :thumb => "20x20>"},:default_url =>'/images/noimage.png'
     
	validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/png']
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates_numericality_of :contact_number, :only_integer => true
  validates_format_of	  :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false
  
  before_update :update_user
  before_create :add_user
  def add_user
    user = User.new
    set_fields
    if self.manager == "1"
     user.is_admin = true
    end 
    user.is_active = true 
    if user.save
      self.user = user unless user.new_record?
    end  
  end
  def update_user
    set_fields
    user.save    
  end
  
  private
  
  def set_fields
    user.username = self.first_name.downcase + self.last_name.downcase
    user.password = self.first_name.downcase + self.last_name.downcase+"123"
  end
  
end
