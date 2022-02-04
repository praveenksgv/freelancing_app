class Request < ApplicationRecord
  belongs_to :job
  belongs_to :user
  default_scope -> {order(updated_at: :desc)}
  validates :status, presence: true
  validate :valid_status 
  validate :valid_method 
  validates_uniqueness_of :user_id, scope: %i[job_id method]



  def valid_status 
    if status == "Pending" || status == "Accepted" || status == "Denied"
      return true
    else  
      errors.add(:status, "should be valid")
    end
  end
  def valid_method
    if method == "Application" || method == "Invitation"
      return true
    else  
      errors.add(:method, "should be valid")
    end
  end

end
