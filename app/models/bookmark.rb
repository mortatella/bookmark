class Bookmark < ActiveRecord::Base
  
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :lists
  
  self.per_page = 2
  
  def self.public
    Bookmark.all
  end
  
  def self.bookmarks_of_list(list_id)
    where("list_id=?",list_id)
  end
  
  def self.public_bookmarks
    bookmarks = List.public_lists.collect{|l| l.bookmarks}.flatten
    
    bookmarks = bookmarks.each do |b|
      b.lists = b.lists & List.public_lists
    end
    
    bookmarks.sort { |a,b| b.created_at <=> a.created_at}
  end
  
  def self.find_public_bookmarks_with_tag(tag)
    public_bookmarks.tags.where("title=?",tag)
  end
  
  def bookmarks_lists_of_user(user)
    user_lists = lists & user.lists
    user_lists = user_lists | lists.select{|l| l.public == true}
    user_lists = user_lists | lists & user.shares.collect{|s| s.list}.flatten
    user_lists.uniq
  end
  
end
