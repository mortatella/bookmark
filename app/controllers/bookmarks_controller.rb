class BookmarksController < ApplicationController
  
  before_filter :get_bookmark, :only=>[:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except=>[:index]
  before_filter :is_user_allowed_to, :except=>[:index, :new, :create]
  
  def get_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
  
  def is_user_allowed_to
    allowed = false
    if(!current_user.bookmarks.index(@bookmark).nil?)
      allowed = true
    else
      write_shares = current_user.shares.find_all{|s| s.write == true}
      write_shares.each do |s|
        if @bookmark.lists.index(s.list)
          allowed = true
        end
      end
    end

    if(!allowed)
      redirect_to root_path
    end
  end
  
  def index
    @bookmarks = Bookmark.public_bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags = Tag.public_tags.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count} 
  end

  def show
  end

  def destroy
  end

  def create

    b = Bookmark.new(:title=>params[:bookmark][:title],:description=>params[:bookmark][:description], :url=>params[:bookmark][:url])
    
    b.lists << current_user.default_list
   

    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each do |l|
         b.lists << List.find(l.first)
      end
    end 
    
    tags = params[:bookmark][:tagstring].split(',')
    
    if !tags.nil?
      tags.each do |t|
        t = t.strip
        t = t.downcase
        
        tag = Tag.find_by_title(t)
        
        if tag.empty?
          tag = current_user.tags.create(:title=>t)
        else
          if !current_user.tags.index(tag).nil?
            current_user.tags << tag.first
          end
        end
        b.tags << tag
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
  
  def user_bookmarks
    if current_user == @user
      @bookmarks = @user.bookmarks
      @tags = @user.tags
    else
      @bookmarks = @user.public_bookmarks
      @tags = @user.public_tags
    end
  end

end
