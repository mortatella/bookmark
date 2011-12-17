class UsersController < ApplicationController
  
   before_filter :get_user, :only=>[:bookmarks, :shared_bookmarks]
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def bookmarks
    if current_user == @user
      @bookmarks = @user.own_and_shared_bookmarks
      @tags = @user.tags
    else
      @bookmarks = @user.public_bookmarks
      @tags = @user.public_tags
    end
    
    @bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end 
  
  def shared_bookmarks
    @bookmarks = @user.shared_bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags = @bookmarks.collect { |b| b.tags }.flatten.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end
end