class Customer < ActiveRecord::Base
  has_one :user, :as => :record
  has_many :bank_accounts
  
  validates_presence_of :first_name ,:last_name, :date_of_birth, :nationality, :address, :contact_number, :photo
  has_attached_file :photo, :styles => {:medium => "120x120>", :thumb => "20x20>"},
					   :default_url =>'/images/missing_thumb.png'

	validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/png']
  has_attached_file :signature, :styles => {:medium => "120x60>"}

	validates_attachment_content_type :signature, :content_type => ['image/jpeg','image/png']
  before_create :add_user
  def add_user
    user = User.new
    user.username = self.first_name + self.last_name
    user.password = self.first_name + self.last_name+"123"
    user.save
    self.user = user unless user.new_record? 
  end

end
