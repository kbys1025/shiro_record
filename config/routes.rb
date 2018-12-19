Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    resources :castles, only: [:show, :create, :edit, :update, :destroy] do
      resources :posts, only: [:show, :create, :edit, :update, :destroy]
    end
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy]
end
