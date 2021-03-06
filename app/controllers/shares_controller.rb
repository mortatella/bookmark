class SharesController < ApplicationController
protected 
  before_filter :authenticate_user!
  
  before_filter :get_share, :only=>[:edit,:destroy,:update]

public  
  def get_share
    @share = Share.find(params[:id])
  end

  def destroy
    @share.destroy
    
    redirect_to lists_path 
  end

  def create
    @list = List.find(params[:list_id])
    
    @share = @list.shares.create(params[:share])
    users = parse_user_string(params[:user])
    
    @validUsers = []

    users.each do |u|
      user = User.find_by_username(u)
      @share.user = user
      
      if @share.valid? && !@validUsers.include?(user.username) #checks if name is stated multiple times
        @validUsers << user.username << ','
      end  
    end

    if @share.valid?
	  @share.save
      redirect_to lists_path
    else
      render :template=>"shares/new"
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
    @share = @list.shares.new
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