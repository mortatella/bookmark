class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :bookmarks
  has_and_belongs_to_many :user
  
  scope :public, joins(:bookmarks).joins(:lists).where(:lists=>{:public=>true}) 
  
  def self.find_by_title(title)
    Tag.where("title=?",title).first
  end

  def title=(title)
    write_attribute(:title, title.strip.downcase)
  end
  
  def self.find_user_tag_by_title(user, tag)
    Tag.where("title = ? AND user_id = ?",tag.title, user.id);
  end	
end
