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
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

	respond_to do |format|
      format.html{ redirect_to bookmarks_path}
      format.xml { head :ok}
	end
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
        
        if tag.nil?
          tag = current_user.tags.create(:title=>t)
        else
          if !current_user.tags.index(tag).nil?
            current_user.tags << tag
          end
        end
        b.tags << tag
      end
    end
    
    b.save!
    
    redirect_to bookmarks_path
    
  end

  def edit
    @tags = ""
    @bookmark.tags.each do |t|  #alle Tags zur Ausgabe in einen String
      if !@bookmark.tags.first.id.eql? t.id #vor erstes Element kein ,
	    @tags << ","
	  end
      @tags << t.title
	end
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
    redirect_to bookmarks_path
	
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
