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
    @bookmarks = Bookmark.public_bookmarks.sort { |a,b| b.created_at <=> a.created_at}
    @tags = Tag.public_tags.sort { |a,b| a.bookmarks.count <=> b.bookmarks.count} 
  end

  def show
  end
  
  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

	respond_to do |format|
      format.html{ redirect_to bookmarks_path}
      format.xml { head :ok}
	end
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
    
    #splits the tags from the textfield
    tags = params[:bookmark][:tagstring].split(',')
    
    if !tags.nil?
      tags.each do |t|
        t = t.strip
        t = t.downcase
        
        #checks if a tag is already created yet
        tag = Tag.find_by_title(t)
        
        #if no, the tag will be created and add to the user
        if tag.nil?
          tag = current_user.tags.create(:title=>t)
        else
          #checks if the tag is part of the user's tags yet
          if !current_user.tags.index(tag).nil?
            current_user.tags << tag
          end
        end
        #adds the tag to the bookmark
        b.tags << tag
      end
    end
    
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
	@bookmark.lists.clear
    @bookmark.lists << current_user.default_list
   
    if !params[:bookmark][:list_ids].nil?
      params[:bookmark][:list_ids].each do |l|
         @bookmark.lists << List.find(l.first)
      end
    end 
  
    tags = params[:bookmark][:tagstring].split(',')
	
	#vor dem update sämtliche tags löschen/zerstören und später neu befüllen	
	@bookmark.tags.each do |t|
	    if Tag.find_by_title(t.title).bookmarks.count == 1 #existiert nur in aktuellem bookmark
		  #tag komplett löschen
	      t.destroy
		else
          #tag nur aus dem array des aktuellen bookmarks löschen, da es wo anders noch existiert
	      @bookmark.tags.delete(t)
		  @bookmark.save
	    end
	end
	
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
        @bookmark.tags << tag
      end
    end 
	
    @bookmark.update_attributes(:url => params[:bookmark][:url], :title => params[:bookmark][:title])
    redirect_to bookmarks_user_path(current_user)
  end

  def new
    @bookmark = Bookmark.new(:title=>DateTime.now, :url=>"http://www.derstandard.at")

    #stores all lists, the user is allowed to write in
    #those are his/her own lists, and all the lists the shared
    #with the write flag true
    @available_lists = current_user.writable_lists
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
