class Employee < ActiveRecord::Base
    has_one :user, :as => :record
    validates_presence_of :first_name ,:last_name, :date_of_birth, :address, :contact_number

end
