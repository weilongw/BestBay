BestBay::Application.routes.draw do

  root to: "products#homepage"

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :notifications

  match '/search', to: 'products#search'
  match '/signup', to: 'users#new'
  match '/profile', to: 'users#profile'
  match '/selling', to: 'users#selling'
  match '/buying', to: 'users#buying'
  match '/notification', to: 'users#notification'
  
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/home', to: 'products#homepage'
  resources :products, only:[:new, :create, :index, :show]

  match 'products/:id/buyout', to: 'products#buyout'
  match 'products/:id/bid', to: 'products#bid'
  match 'products/:id/rate', to: 'products#rate'
  match 'post' => 'products#new'
  match 'products/:id/cancel', to: 'products#cancel'

  #match '/products/temp' => 'products#temp'

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
  # just remember to delete public/index.html.backup.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
