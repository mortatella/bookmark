class SharesController < ApplicationController
  
  before_filter :authenticate_user!
  
  before_filter :get_share, :only=>[:edit,:destroy,:update]
  
  def get_share
    @share = Share.find(params[:id])
  end

  def destroy
    @share.destroy
    
    redirect_to lists_path
  end

  def create
    @share = Share.new(params[:share])
    list = List.find(params[:list_id])
    
    params[:user][:user_id].each do |u|
      user = User.find(u.to_i)
      share = list.shares.create(params[:share])
      share.user = user
      share.save
    end
    
    redirect_to lists_path
  end

  def edit
    
  end

  def update
    @share.update_attributes(:write=>params[:share][:write])
    @share.save
    redirect_to lists_path
  end

  def new
    @share = Share.new
    @available_users = User.all
    @shareable_lsits = current_user.lists
  end

end
