Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'broadcast' => 'microposts#broadcast'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  post 'favorite'=> 'favorites#update'
  post 'retweet' => 'retweets#update'


  resources :users do
    member do
      get :following, :followers, :favorites, :retweets
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end