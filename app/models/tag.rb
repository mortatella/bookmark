class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :user
  
  def self.find_by_title(title)
    Tag.where("title=?",title).first
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
