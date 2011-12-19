class ListsController < ApplicationController

  before_filter :get_list, :only=>[:show, :edit, :update, :destroy, :share, :bookmarks]
  
  def get_list
    @list = List.find(params[:id])
  end

  def index
    @lists = current_user.lists
  end

  def show
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
