Rails.application.routes.draw do



  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #These are routes used by sample_app

  # root 'static_pages#home'
  # get '/about', to: 'static_pages#about'
  # get '/contact', to: 'static_pages#contact'
  # get '/help', to: 'static_pages#help'
  # get '/signup', to: 'users#new'

  
  # resources :users do
  #   member do 
  #     get :following, :followers
  #   end
  # end
  # resources :microposts,      only: [:create, :destroy]
  # resources :relationships, only: [:create, :destroy]

  get 'jobs/new'
  get 'jobs/show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  

  root 'static_pages#home'
  get '/howitworks', to: 'static_pages#howitworks'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get 'signup', to: 'users#new'
  resources :users
  resources :specializations, only: [:create, :destroy]
  resources :jobs, only: [:new, :create, :show, :edit, :update, :destroy]
  resources :requests, only: [:create, :destroy, :update]
  get '/applications', to: 'requests#applications'
  get '/invitations', to: 'requests#invitations'

end
