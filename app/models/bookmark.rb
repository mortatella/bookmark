class Bookmark < ActiveRecord::Base
  
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :lists
  
  #returns all bookmarks belonging to public lists
  def self.public_bookmarks
    bookmarks = List.public_lists.collect{|l| l.bookmarks}.flatten
    bookmarks.sort { |a,b| b.created_at <=> a.created_at}
  end
  
  def public_lists
    lists & List.public_lists
  end
  
  #returns all public bookmarks tagged with tag
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
