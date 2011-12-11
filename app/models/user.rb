class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstName, :lastName, :username
  

  
  has_one  :list, :foreign_key => :default_list
  has_many :lists
  has_many :bookmarks, :through=>:list
  has_many :shares
  has_many :tags
  
  
  def writable_lists
    w_lists = Array.new(lists)
    w_lists.delete(default_list)
    return w_lists
  end
  
  def bookmarks
    tmp = []
    lists.each do |l|
      if(l.bookmarks)
        l.bookmarks.each do |b|
          tmp << b
        end
      end
    end
    
    tmp.uniq
  end
end
