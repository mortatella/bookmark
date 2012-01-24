class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstName, :lastName, :username
  

  belongs_to :default_list, :foreign_key=>:default_list_id, :class_name=>'List'
  has_many :lists
  has_many :bookmarks, :through => :lists
  has_many :shares
  has_and_belongs_to_many :tags
  
  validates :firstName, :presence => true
  validates :lastName, :presence => true
  validates :username, :presence => true 
  validates_uniqueness_of :username
  validates :email, :presence => true
  
  validates :password, :presence => true
  validates :password_confirmation, :presence => true
  validates_confirmation_of :password
  
  def writable_lists#used
    w_lists = lists.to_ary #| shares.select{|s| s.write == true}.collect{|s| s.list}.flatten.uniq
    w_lists.delete(default_list)
    return w_lists
  end
  
  def bookmarks_with_tag(tag)#used
    tags.select{|t| t.title == tag.title}.collect{|t| t.bookmarks}.flatten.uniq
  end
  
  def public_bookmarks_with_tag(tag)#used
    bookmarks_with_tag(tag) & public_bookmarks
  end

  def public_bookmarks#used
    Bookmark.public_bookmarks_of_user(self)
  end
  
  def own_and_shared_bookmarks#used
    Bookmark.own_and_shared_bookmarks_of_user(self)
  end
  
end
