class SharesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
  end

  def show
  end

  def destroy
  end

  def create
    @share = Share.new
  end

  def edit
  end

  def update
  end

  def new
    @share = Share.new
    @available_users = User.all
    @shareable_lsits = current_user.lists
  end
  
  def new_share_for_list(list_id)
    
  end

end
