class UsersController < ApplicationController
  
   before_filter :get_user, :only=>[:bookmarks, :shared_bookmarks, :tag]
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def bookmarks
    if current_user == @user
      @bookmarks = @user.own_and_shared_bookmarks
      @tags = @user.used_own_and_shared_tags
      @public_only = false
    else
      @bookmarks = @user.public_bookmarks
      @tags = @user.public_tags
      @public_only = true
    end
    
    @bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count}
    @tags.each do |t|
      t.bookmarks = t.bookmarks & @bookmarks
    end
  end 
  
  def shared_bookmarks
    @bookmarks = @user.shared_bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags = @bookmarks.collect { |b| b.tags }.flatten.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end
  
  def tag
    @tag = Tag.find(params[:tag_id])
    
    if current_user == @user 
      @bookmarks = current_user.bookmarks_with_tag(@tag)
      @public_only = false;
    else
      @bookmarks = @user.public_bookmarks_with_tag(@tag)
      @public_only = true
    end
    
    @bookmarks.sort {|a,b| b.created_at <=> a.created_at}
  end
  
end