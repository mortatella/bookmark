class TagsController < ApplicationController
  
  before_filter :get_tag, :only=>[:show, :edit, :update, :destroy]
  
  def get_tag
    @tag = Tag.find(params[:id])
  end
  
  def show
    @bookmarks = @tag.bookmarks.public.paginate(:page => params[:page])
  end
end
