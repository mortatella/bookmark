class List < ActiveRecord::Base
  belongs_to :user
  has_many :shares
  has_many :manifests
  has_many :bookmarks, :through=>:manifests
  
  def self.users_lists(user_id)
    where("user_id=?",user_id)
  end
  
  def self.public_lists
    where("public=?",true)
  end
  
end
