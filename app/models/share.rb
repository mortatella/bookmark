class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  
  validates :user_id, :presence => { :message => "not found" }
  validate :validateCurrentUser
 
  
  def validateCurrentUser
    errors.add(:user_id, ", can't share list with yourself") if user_id == list.user.id
  end
  
end
