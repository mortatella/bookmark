class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :username
  
  belongs_to :default_list, :foreign_key=>:default_list_id, :class_name=>'List'
  has_many :lists
  has_many :bookmarks, :through => :lists
  has_many :shares
  has_and_belongs_to_many :tags
  
#  scope :writable_lists, includes(:lists).where('lists.id _not'=>user.default_list.id)
  
  def writable_lists
    w_lists = lists.to_ary | shares.select{|s| s.write == true}.collect{|s| s.list}.flatten.uniq
    w_lists.delete(default_list)
    return w_lists
  end
  
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :username, :presence => true 
  validates_uniqueness_of :username
  validates :email, :presence => true
  
  validates :password, :presence => true
  validates :password_confirmation, :presence => true
  validates_confirmation_of :password
  
  def writable_lists
    w_lists = lists.to_ary #| shares.select{|s| s.write == true}.collect{|s| s.list}.flatten.uniq
    w_lists.delete(default_list)
    return w_lists
  end
  
  def bookmarks_with_tag(tag)
    tags.select{|t| t.title == tag.title}.collect{|t| t.bookmarks}.flatten.uniq
  end
  
  def public_bookmarks_with_tag(tag)
    bookmarks_with_tag(tag) & public_bookmarks
  end

  def public_bookmarks
    Bookmark.public_bookmarks_of_user(self)
  end
  
  def own_and_shared_bookmarks
    Bookmark.own_and_shared_bookmarks_of_user(self)
  end
  
end
