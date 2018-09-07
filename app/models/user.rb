require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  belongs_to :record, :polymorphic => true
  attr_accessible :username, :password

  validates_presence_of :username,:password
  
  before_create :encrypt_password
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)  
  end
    def self.authenticate(username, submitted_password)

        user = User.find_by_username(username)
        if submitted_password.present?
          if (user && user.has_password?(submitted_password))
            return user
          else
            return nil
          end
        end

      end
  
  
  private
  
		def encrypt_password
      self.salt = make_salt  if new_record?
      self.encrypted_password = encrypt(password)
              
		end

		def encrypt(string)
			secure_hash("#{salt}#string") # temp implementation
		end

		def make_salt
			secure_hash("#{Time.now.utc}#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
