class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  
  validates :user_id, :presence => { :message => "User(s) not found" }
  
end
