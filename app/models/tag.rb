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
end
