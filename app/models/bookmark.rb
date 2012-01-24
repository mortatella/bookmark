class Bookmark < ActiveRecord::Base
  
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :lists
  
  default_scope order('bookmarks.created_at DESC')
  scope :public, joins(:lists).where('lists.public'=>true).includes(:lists).where('lists.public'=>true)
  
  self.per_page = 10
  
  #returns all public bookmarks tagged with tag
  def self.find_public_bookmarks_with_tag(tag)
    public_bookmarks.joins(:tags).where(:tags => {:title => tag})
  end
  
  def self.of_user(user)
    Bookmark.includes(:lists).where(:lists=>{:user_id=>user.id})
  end
  
  def self.shared_bookmarks_of_user(user)
    list_ids = user.shares.map{|s| s.list}.flatten.map{|l| l.id}.flatten
    Bookmark.includes(:lists).where(:lists=>{:id => list_ids})
  end
  
  def self.public_bookmarks_of_user(user)
    of_user(user).joins(:lists).where(:lists=>{:public=>true})
  end
  
  def self.own_and_shared_bookmarks_of_user(user)
    list_ids = user.shares.map{|s| s.list}.flatten.map{|l| l.id}.flatten
    Bookmark.includes(:lists).where("lists.user_id= ? or lists.id IN (?)",user.id,list_ids)
  end
  
  #parses the tag string and creates an array of tags
  def self.parse_tag_string(tagstring)
    tags = tagstring.split(',') 
    tags = tags.map do |t|
      t = t.strip
      t = t.downcase
    end
    tags.uniq!
    return tags
  end
  
  def set_tags(user, newtags)
    if !newtags.nil?
      newtags.each do |t|
        t = t.strip
        t = t.downcase
        
        tag = Tag.find_by_title(t)
        
        if tag.nil?
          tag = user.tags.create(:title=>t)
        else
          if !user.tags.index(tag).nil?
            user.tags << tag
          end
        end
        tags << tag
      end
    end 
  end
  
end
