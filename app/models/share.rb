class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  
  validates :user_id, :presence => { :message => "not found" }
  validate :validateCurrentUser
  
 @list = List.find(params[:id])
  @share.list = @list
  
  def validateCurrentUser
    errors.add(:user_id, ", can't share list with yourself") if user_id == @share.list.user.id
  end
  
end
