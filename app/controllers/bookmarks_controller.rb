class BookmarksController < ApplicationController
  
  #filter for getting the bookmark by the id in the params field
  before_filter :get_bookmark, :only=>[:show, :edit, :update, :destroy]
  
  #checks if a user is logged in
  before_filter :authenticate_user!, :except=>[:index]
  
  #checks if the logged in user (current_user) is allowed to do the actions
  before_filter :is_user_allowed_to, :except=>[:index, :new, :create, :destroy]
  
  #gets the bookmark defined by the id in the params-field
  def get_bookmark
    @bookmark = Bookmark.find(params[:id])
  end
  
  #if the user is not allowed to do the current action,
  #a redirection to the root is done
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
  
  #shows all public bookmarks and their tags
  def index
    @bookmarks = Bookmark.public.paginate(:page => params[:page])
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

    b = Bookmark.new(:title=>params[:bookmark][:title],:description=>params[:bookmark][:description], :url=>params[:bookmark][:url])
    
    #every bookmark is stored in the users default_list
    b.lists << current_user.default_list
    
    #iterates through all checked lists the user has selected in the form
    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each do |l|
         #ads the bookmark to the list
         b.lists << List.find(l.first)
      end
    end 
    
    tags = parse_tag_string(params[:bookmark][:tagstring])	
    
    set_tags(b, tags)
    
    b.save!
    
    #redirects to the users bookmark page
    redirect_to bookmarks_user_path(current_user)
  end

  def edit
    @tags = ""
    @bookmark.tags.each do |t|  #alle Tags zur Ausgabe in einen String
    if !@bookmark.tags.first.id.eql? t.id #vor erstes Element kein ,
        @tags << ","
      end
      @tags << t.title
    end
    
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
   
    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each do |l|
         @bookmark.lists << List.find(l.first)
      end
    end 
    
    @bookmark.lists << tmpList
    
    @bookmark.tags.clear  
    
    tags = parse_tag_string(params[:bookmark][:tagstring])	
    set_tags(@bookmark, tags)    
	
    @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title])
    redirect_to bookmarks_user_path(current_user)
  end
  
  def set_tags(bookmark, tags)
    if !tags.nil?
      tags.each do |t|
        t = t.strip
        t = t.downcase
        
        tag = Tag.find_by_title(t)
        
        if tag.nil?
          tag = current_user.tags.create(:title=>t)
        else
          if !current_user.tags.index(tag).nil?
            current_user.tags << tag
          end
        end
        bookmark.tags << tag
      end
    end 
  end

  def new
    @bookmark = Bookmark.new(:title=>DateTime.now, :url=>"http://www.derstandard.at")

    #stores all lists, the user is allowed to write in
    #those are his/her own lists, and all the lists the shared
    #with the write flag true
    @available_lists = current_user.writable_lists
  end
  
  #parses the tag string and creates an array of tags
  def parse_tag_string(tagstring)
    tags = tagstring.split(',') 
    tags = tags.map do |t|
      t = t.strip
      t = t.downcase
    end
    tags.uniq!
    return tags
  end

end
