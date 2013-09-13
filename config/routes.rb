ParkBenchProjects::Application.routes.draw do
  root :to => 'projects#index'

  resources :projects do
    resources :donations
    resources :updates
    resources :mediafiles

    resources :events

    resources :commitments

    get 'payments', to: 'payments#show'
    post 'payments', to: 'payments#create'
  end

  resources :users do
    get 'bankaccounts', to: 'bankaccounts#show'
    post 'bankaccounts', to: 'bankaccounts#create'
  end

  get 'starts', to: 'starts#index'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'sign_in', to: 'sessions#sign_in', as: 'sign_in'

  match 'auth/facebook', as: 'sign_in_facebook'
  match 'auth/twitter', as: 'sign_in_twitter'

  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'
end
