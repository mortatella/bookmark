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
  
  
  def writable_lists
    w_lists = lists.to_ary #| shares.select{|s| s.write == true}.collect{|s| s.list}.flatten.uniq
    w_lists.delete(default_list)
    return w_lists
  end
  
  def shared_lists
    shares.collect{|s| s.list}.flatten
  end
  
  def find_bookmarks_with_tag(tag)
    tags.select{|t| t.title=tag.title}.collect{|t| t.bookmarks}.flatten.uniq
  end
  
  def shared_bookmarks
   shares.collect{|s| s.list.bookmarks}.flatten
  end
  
  def public_bookmarks
    lists.select{|l| l.public}.collect{|l| l.bookmarks}.flatten
  end
  
  def public_tags
    public_bookmarks.collect{|b| b.tags}.flatten.uniq
  end
  
  def own_and_shared_bookmarks
    all_bookmarks = bookmarks | shared_bookmarks
    
    # all_bookmarks.each do |b|
#       b.lists = b.bookmarks_lists_of_user(User.find(id))
#     end
#     
    return all_bookmarks
  end
  
  def used_tags
    bookmarks.collect{|b| b.tags}.flatten.uniq
  end
  
  def used_own_and_shared_tags
    own_and_shared_bookmarks.collect{|b| b.tags}.flatten.uniq
  end
  
end
