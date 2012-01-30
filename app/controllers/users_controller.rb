class UsersController < ApplicationController 
  def bookmarks
    if current_user == @user
      @bookmarks = @user.own_and_shared_bookmarks.paginate(:page => params[:page])
      @public_only = false
    else
      @bookmarks = @user.public_bookmarks.paginate(:page => params[:page])
      @public_only = true
    end
    
    @tags = @bookmarks.collect{|b| b.tags}.flatten.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}.uniq
  end 
  
  protected
  
  autocomplete :tag, :title
   autocomplete :user, :username
   before_filter :get_user, :only=>[:bookmarks, :shared_bookmarks, :tag]
  
  def get_user
    @user = User.find(params[:id])
  end
   
end