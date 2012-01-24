class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  
  validates :user_id, :presence => { :message => "not found" }
  # the combination of user_id and list_id is only allowed once
  validates :user_id, :uniqueness => { :scope => :list_id, :message => "already stated" }
  validate :validate_current_user
 
  def validate_current_user
    errors.add(list.user.username, ", can't share list with yourself") if user_id == list.user.id
  end
  
end