class Employee < ActiveRecord::Base
  has_one :user, :as => :record, :dependent => :destroy
  attr_accessor :manager
  attr_accessible :first_name , :middle_name,:last_name, :date_of_birth, :email,:address, :contact_number, :photo, :manager
  validates_presence_of :first_name ,:last_name, :date_of_birth, :address, :contact_number
  has_attached_file :photo, :styles => {:medium => "120x120>", :thumb => "20x20>"}
	validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/png']
  before_update :update_user
  before_create :add_user
  def add_user
    user = User.new
    user.username = self.first_name.downcase + self.last_name.downcase
    user.password = self.first_name.downcase + self.last_name.downcase+"123"
    if self.manager == "1"
     user.is_admin = true
    end 
    user.is_active = true 
    user.save
    self.user = user unless user.new_record? 
  end
   def update_user
    user.username = self.first_name.downcase + self.last_name.downcase
    user.password = self.first_name.downcase + self.last_name.downcase+"123"
    user.save
    
  end
end
