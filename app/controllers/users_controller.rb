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
  
  def tag
    @tag = Tag.find(params[:tag_id])
    
    if current_user == @user 
      @bookmarks = current_user.bookmarks_with_tag(@tag).paginate(:page => params[:page])
      @public_only = false
    else
      @bookmarks = @user.public_bookmarks_with_tag(@tag).paginate(:page => params[:page])
      @public_only = true
    end
    
    @tags = @bookmarks.collect{|b| b.tags}.flatten.uniq.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}
    @public_only = true
  end
  
  protected
  
  autocomplete :tag, :title
   autocomplete :user, :username
   before_filter :get_user, :only=>[:bookmarks, :shared_bookmarks, :tag]
  
  def get_user
    @user = User.find(params[:id])
  end
   
end