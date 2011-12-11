class BookmarksController < ApplicationController

  before_filter :authenticate_user!, :except=>[:index]
  before_filter :get_bookmark, :only=>[:show, :edit, :update, :destroy]
  
  def get_list
    @bookmark = Bookmark.find(params[:id])
  end
  
  def index
    if ! :authenticate_user?
      @bookmarks = current_user.bookmarks
    else
      @bookmarks = Bookmark.public_bookmarks
    end
  end

  def show
  end

  def destroy
  end

  def create

    b = Bookmark.new(:title=>params[:bookmark][:title],:description=>params[:bookmark][:description], :url=>params[:bookmark][:url])
    
    b.lists << current_user.lists.first
    
    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each {|l| b.lists << List.find(l)}
    end 
    
    tags = params[:bookmark][:tagstring].split(',')
    
    
    
    if !tags.nil?
      user_tags = Tag.tags_of_user(current_user.id)
              
      tags.each do |t|
        t = t.strip
        t = t.downcase
        existing_tags = Tag.find_tag_of_user_by_title(current_user.id, t)
        
        if existing_tags.empty?
          new_tag = Tag.new(:title=>t, :user_id=>current_user.id)
          new_tag.save
          b.tags << new_tag
        else
          b.tags << existing_tags.first
        end
      end
    end
    
    b.save!
    
    redirect_to bookmarks_path
    
  end

  def edit
  end

  def update
  end

  def new
    @bookmark = Bookmark.new(:title=>DateTime.now, :url=>"http://www.derstandard.at")
    @availableLists = current_user.lists
  end

end
