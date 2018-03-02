Rails.application.routes.draw do
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
