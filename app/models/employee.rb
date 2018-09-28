class Employee < ActiveRecord::Base
  has_one :user, :as => :record, :dependent => :destroy
  attr_accessor :manager
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
    user = User.add(self.first_name, self.last_name,self.manager)
    user.is_active = true 
    self.user = user unless user.new_record?
  end
  def update_user
    user.set_fields(self.first_name, self.last_name)  
  end  
end
