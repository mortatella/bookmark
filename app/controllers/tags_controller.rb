class TagsController < ApplicationController
  
  before_filter :get_tag, :only=>[:show, :edit, :update, :destroy]
  
  def get_tag
    @tag = Tag.find(params[:id])
  end
  
  def show
    @bookmarks = @tag.public_bookmarks.sort {|a,b| b.created_at <=> a.created_at}
  end
end
