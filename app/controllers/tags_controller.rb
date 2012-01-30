class TagsController < ApplicationController

  def show
    if(params[:user_id])
        user = User.find(params[:user_id])
        if current_user == user 
          @bookmarks = current_user.bookmarks_with_tag(@tag).paginate(:page => params[:page])
          @public_only = false
       else
         @bookmarks = user.public_bookmarks_with_tag(@tag).paginate(:page => params[:page])
         @public_only = true
       end
       @public_only = true
    else 	
      @bookmarks = @tag.bookmarks.public.paginate(:page => params[:page])
      @public_only = true
    end
    @tags = @bookmarks.collect{|b| b.tags}.flatten.uniq.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end
  
  protected 
  before_filter :get_tag, :only=>[:show]
  
  def get_tag
    @tag = Tag.find(params[:id])
  end
  
end
