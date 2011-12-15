class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstName, :lastName, :username
  

  belongs_to :default_list, :foreign_key=>:default_list_id, :class_name=>'List'
  has_many :lists
  has_many :bookmarks, :through=>:list
  has_many :shares
  has_and_belongs_to_many :tags
  
  
  def writable_lists
    w_lists = Array.new(lists)
    w_lists.delete(default_list)
    return w_lists
  end
  
  def bookmarks
    tmp = []
    lists.each do |l|
      if(l.bookmarks)
        tmp = tmp | l.bookmarks
      end
    end
   return tmp
  end
end
