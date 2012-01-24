Bookmakr::Application.routes.draw do

  get 'users/autocomplete_user_username'
  get 'users/autocomplete_tag_title'

  resources :bookmarks
  resources :tags 
  
  resources :lists do
    get :share, :on=>:member
  end
  
  resources :shares 
  
  match "/users/autocomplete_user_username" => "users#autocomplete_user_username", :as=>"autocomplete_user_username_users"
  match "/users/autocomplete_tag_title" => "users#autocomplete_tag_title", :as=>"autocomplete_tag_title_users"
  
  match "/users/:id/bookmarks" => "users#bookmarks", :as=>"bookmarks_user"
  match "/users/:id/sharedbookmarks" => "users#shared_bookmarks", :as=>"shared_bookmarks_user"
  match "/users/:id/tag/:tag_id/" => "users#tag", :as=>"bookmarks_tags_user"
  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "devise/sessions"}

  root :to => 'bookmarks#index'
end

