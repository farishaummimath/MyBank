class User < ActiveRecord::Base
  belongs_to :record, :polymorphic => true
  validates_presence_of :username,:password
end
