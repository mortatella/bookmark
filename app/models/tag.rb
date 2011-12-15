class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :user
  
  def self.find_by_title(title)
    Tag.where("title=?",title)
  end
  
  def self.tags_of_user(user_id)
    Tag.where("user_id=?",user_id)
  end
  
  def self.find_tag_of_user_by_title(user_id, title)
    tags_of_user(user_id).find_by_title(title).limit(1)
  end
  
  def self.public_tags
    tags = []
    Bookmark.public_bookmarks.each {|b| tags = tags | b.tags}
    
    return tags;
  end
 
  def title=(title)
    write_attribute(:title, title.downcase)
  end
    
end
