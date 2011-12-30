class RegistrationsController < Devise::RegistrationsController
  
   before_filter :get_user, :only=>[:bookmarks]
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def create
    super
    if  @user.valid?
      @user.default_list = @user.lists.create(:title=>@user.username+"s default list",:description=>"Default list of "+@user.username)
      @user.default_list.user = @user;
      @user.save
     end
  end  
end