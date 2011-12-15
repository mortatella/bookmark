class List < ActiveRecord::Base
  
  belongs_to :user
  has_many :shares
  has_and_belongs_to_many :bookmarks
  
  def self.users_lists(user_id)
    where("user_id=?",user_id)
  end
  
  def self.public_lists
    where("public=?",true)
  end
  
end
