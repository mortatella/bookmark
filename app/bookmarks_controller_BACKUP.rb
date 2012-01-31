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
    


    if params[:bookmark][:list_ids] 
      params[:bookmark][:list_ids] << current_user.default_list.id
    else
      params[:bookmark][:list_ids] = current_user.default_list.id

    end
    

    b = Bookmark.new(params[:bookmark])

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
    
    @bookmark.tags.clear  
    
    tags = Bookmark.parse_tag_string(params[:tagstring])	
    @bookmark.set_tags(current_user, tags)    
    
    @bookmark.update_attributes(params[:bookmark])
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
  
  before_filter :add_default_list_to_params, :only=>[:create, :update]
  
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
  
  def add_default_list_to_params
    if params[:bookmark][:list_ids] 
      params[:bookmark][:list_ids] << current_user.default_list.id
    else
      params[:bookmark][:list_ids] = current_user.default_list.id
    end
  end

end
