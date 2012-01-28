class ListsController < ApplicationController
protected
  before_filter :get_list, :only=>[:show, :edit, :update, :destroy, :share, :bookmarks]

public  
  def get_list
    @list = List.find(params[:id])
  end

  def index
    if signed_in?
      @lists = current_user.lists
    else
      redirect_to root_path
    end
  end

  def show
    if signed_in? && current_user.lists.index(@list)
      @bookmarks = @list.bookmarks.paginate(:page => params[:page])
      @public_only = false
    elsif @list.public
      @bookmarks = @list.bookmarks.paginate(:page => params[:page])
      @public_only = true
    else
      redirect_to root_path
    end  
    
    if @boomarks
    	@tags = @bookmarks.collect{|b| b.tags}.flatten.uniq.sort{ |a,b| a.bookmarks.count <=> b.bookmarks.count}
    end  
  end
 
  def destroy
    @list.bookmarks.each do |b|
      #if a bookmark is only in the list to destroy and the users default_list it can be destroyed
      if(b.lists.count==2)
        b.delete
      else
        b.lists.delete(@list)
        b.save
      end
    end
    
    @list.shares.each do |s|
      s.destroy
    end
    @list.destroy
    
    redirect_to lists_path
  end

  def create
    current_user.lists.create(params[:list])
    
    redirect_to lists_path
  end

  def edit
  end

  def update
    @list.update_attributes(params[:list])
    
    redirect_to lists_path
  end

  def new
    @list = List.new
  end
  
  def share
    @share = @list.shares.new
    @users = User.all_users_except current_user
    render :template=>'shares/new'
  end
end
