Rails.application.routes.draw do
  get 'sessions/new'

  resources :users do
    collection { post :import }
  end
  resources :liners do
    collection { post :import }
  end
  resources :companies do
    collection { post :import }
  end
  root to: "companies#index"
  get    '/register',   to: 'users#new'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post    '/liner',      to: 'liners#get'
  post    '/liner/replace',      to: 'liners#replace'
  post    '/liner/swap',      to: 'liners#swap'
  post    '/liner/measurement',      to: 'liners#measure'
end
