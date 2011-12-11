class RegistrationsController < Devise::RegistrationsController
  def create
    super
    @user.default_list = List.new(:title=>"default list", :description=>"users default list", :public=>false)
    @user.save!
  end
end