class RegistrationsController < Devise::RegistrationsController
  
   before_filter :get_user, :only=>[:bookmarks]
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def create
    super
    @user.default_list = @user.lists.create(:title=>@user.username+"s default list",:description=>"Default list of "+@user.username)
    @user.save
  end
  
  
  def bookmarks
    if current_user == @user
      @bookmarks = @user.bookmarks
      @tags = @user.tags
    else
      @bookmarks = @user.public_bookmarks
      @tags = @user.public_tags
    end
    
    @bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end
  
end