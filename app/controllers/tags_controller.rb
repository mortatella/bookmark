class TagsController < ApplicationController
  
  before_filter :get_tag, :only=>[:show, :edit, :update, :destroy]
  
  def get_tag
    @tag = Tag.find(params[:id])
  end
  
  def index
  end

  def show
    if !signed_in?
      @bookmarks = find_public_bookmarks_with_tag(@tag)
    else
      @bookmarks = current_user.find_bookmarks_with_tag(@tag)
    end  
      @bookmarks.sort {|a,b| b.created_at <=> a.created_at}
  end

  def destroy
  end

  def create
  end

  def edit
  end

  def update
  end

  def new
  end

end
