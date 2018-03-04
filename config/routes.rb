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

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
