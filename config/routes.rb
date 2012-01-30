Bookmakr::Application.routes.draw do

  get 'users/autocomplete_user_username'
  get 'users/autocomplete_tag_title'

  resources :bookmarks
  resources :tags
  
  resources :lists do
    get :share, :on=>:member
  end
  
  resources :shares 
  
  resources :users do
    get :bookmarks, :on=>:member
    get :autocomplete_tag_title_users
    get :autocomplete_user_username_users
    resources :tags, :only => :show
  end
  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "devise/sessions"}, :path=>"account"

  root :to => 'bookmarks#index'
end

