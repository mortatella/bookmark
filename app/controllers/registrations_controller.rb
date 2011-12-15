class RegistrationsController < Devise::RegistrationsController
  def create
    super
    @user.default_list = @user.lists.create(:title=>@user.username+"s default list",:description=>"Default list of "+@user.username)
    @user.save
  end
  
  def show_bookmarks
    @bookmarks = current_user.bookmarks
  end
  
end