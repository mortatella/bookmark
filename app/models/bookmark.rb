class Bookmark < ActiveRecord::Base
  
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :lists
  
  def self.public
    Bookmark.all
  end
  
  def self.bookmarks_of_list(list_id)
    where("list_id=?",list_id)
  end
  
  def self.public_bookmarks
    
    bookmarks = []
    
    List.public_lists.each {|l| bookmarks = bookmarks | l.bookmarks}
    
    return bookmarks
  end
  
end
