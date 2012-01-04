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

    
    parse_user_string(params[:user]).each do |u|
    #  if User.find_by_username(u) != current_user #filter current_user
        user = User.find_by_username(u)
        share = list.shares.create(params[:share])
        share.user = user
        share.save	       
      end      
  end

  def edit
    
  end

  def update
    @share.update_attributes(:write=>params[:share][:write])
    @share.save
    redirect_to lists_path
  end

  def new
    @list = List.find(params[:listid])
    @share = @list.shares.new()
    @users = User.all.sort{|a,b| a.username <=> b.username }
    @users.delete(current_user)
  end
  
  #parses the user string and creates an array of users
  def parse_user_string(userstring)
    users = userstring.split(',') 
    users = users.map do |u|
      u = u.strip
    end
    return users
  end

end
