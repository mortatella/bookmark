class TagsController < ApplicationController

  def show
    @bookmarks = @tag.bookmarks.public.paginate(:page => params[:page])
    @tags = @bookmarks.collect{|b| b.tags}.flatten.uniq.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end
  
  protected 
  before_filter :get_tag, :only=>[:show]
  
  def get_tag
    @tag = Tag.find(params[:id])
  end
  
end
