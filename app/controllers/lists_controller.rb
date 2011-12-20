class ListsController < ApplicationController

  before_filter :get_list, :only=>[:show, :edit, :update, :destroy, :share, :bookmarks]
  
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
      @public_only = false
    elsif @list.public
      @public_only = true
    else
      redirect_to root_path
    end
  end

  def destroy
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
    @share = @list.shares.new()
    @users = User.all.sort{|a,b| a.username <=> b.username }
    @users.delete(current_user)
  end
  
  
end
