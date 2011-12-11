class ListsController < ApplicationController

  before_filter :get_list, :only=>[:show, :edit, :update, :destroy]
  
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
    @list = List.new(params[:list])
    @list.user = current_user
    @list.save
    
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

end
