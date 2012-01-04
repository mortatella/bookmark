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
  
  #match "/list/:listid/share" =>"shares#new", :as=>"share_list"
  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "devise/sessions"}


  
  root :to => 'bookmarks#index'
  
  
  
  #get "users/index"

  #get "users/show"

  #get "users/destroy"

  #get "users/create"

  #get "users/edit"

  #get "users/update"

  #get "users/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

