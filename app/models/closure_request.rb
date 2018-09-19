class ClosureRequest < ActiveRecord::Base
  belongs_to :bank_account
  validates_presence_of :reason
  attr_accessible :reason, :bank_account_id, :status
end
