ParkBenchProjects::Application.routes.draw do
  root :to => 'projects#index'

  resources :projects do
    resources :donations

    resources :events

    get 'payments', to: 'payments#show'
    post 'payments', to: 'payments#create'

    get 'bankaccounts', to: 'bankaccounts#show'
    post 'bankaccounts', to: 'bankaccounts#create'
  end

  resources :users

  get 'starts', to: 'starts#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'sign_in', to: 'sessions#sign_in', as: 'sign_in'

  match 'auth/facebook', as: 'sign_in_facebook'
  match 'auth/twitter', as: 'sign_in_twitter'

  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
