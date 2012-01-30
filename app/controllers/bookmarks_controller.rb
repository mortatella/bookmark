class BookmarksController < ApplicationController

  public
  #shows all public bookmarks and their tags
  def index
    @bookmarks = Bookmark.public.paginate(:page => params[:page])
    @public_only = true
    @tags = @bookmarks.collect{|b| b.tags}.flatten.uniq.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}
  end

  def show
  end
  
  def destroy
    @bookmark.destroy
    
    #redirect to the page the request came from
    redirect_to(request.env["HTTP_REFERER"])
  end


  def create
    b = Bookmark.new(params[:bookmark])
 
    #every bookmark is stored in the users default_list
    b.lists << current_user.default_list
    
    #iterates through all checked lists the user has selected in the form
    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each do |l|
         b.lists << List.find(l.first)
      end
    end
    
    tags = Bookmark.parse_tag_string(params[:tagstring])	
    
    b.set_tags(current_user, tags)
    
    b.save!
    
    #redirects to the users bookmark page
    redirect_to bookmarks_user_path(current_user)
  end

  def edit
    @tags = @bookmark.tags.map { |t| t.title }.join(', ')

    #stores all lists, the user is allowed to write in
    #those are his/her own lists, and all the lists the shared
    #with the write flag true
    @available_lists = current_user.writable_lists
  end

  def update
    #listen löschen und neu setzen
     tmpList = @bookmark.lists.to_ary - current_user.lists
     @bookmark.lists.clear
     @bookmark.lists << current_user.default_list
   
    if params[:bookmark][:list_ids]
      params[:bookmark][:list_ids].each do |l|
         @bookmark.lists << List.find(l.first)
      end
    end 
    
    @bookmark.lists << tmpList
    
    @bookmark.tags.clear  
    
    tags = Bookmark.parse_tag_string(params[:tagstring])	
    @bookmark.set_tags(current_user, tags)    

    @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title])
    redirect_to bookmarks_user_path(current_user)
  end

  def new
    @bookmark = Bookmark.new

    #stores all lists, the user is allowed to write in
    #those are his/her own lists, and all the lists the shared
    #with the write flag true
    @available_lists = current_user.writable_lists
  end
  
  
  protected
  
  before_filter :get_bookmark, :only=>[:show, :edit, :update, :destroy]
  
  before_filter :authenticate_user!, :except=>[:index]
  
  before_filter :is_user_allowed_to, :except=>[:index, :new, :create, :destroy]
  
  
  #gets the bookmark defined by the id in the params-field
  def get_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
  
  
  
  #if the user is not allowed to do the current action,
  #a redirection to the root is done
  def is_user_allowed_to
    if !@bookmark.lists.find_all{|l| l.user == current_user}.empty?
      return
    end
    else if(!current_user.is_bookmark_write_shared(@bookmark).empty?)
	return  
    end

    redirect_to root_path
  end

end
