class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :user
  
  scope :public, joins(:bookmarks).joins(:lists).where(:lists=>{:public=>true}) 
  
  def self.find_by_title(title)
    Tag.where("title=?",title).first
  end
  
#   def self.public_tags
#     Bookmark.public_bookmarks.collect {|b| b.tags}.flatten.uniq
#   end
  
#   def public_bookmarks
#     bookmarks & Bookmark.public_bookmarks
#   end
 
  def title=(title)
    write_attribute(:title, title.strip.downcase)
  end
end
