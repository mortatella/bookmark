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
end