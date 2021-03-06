Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  get     '/home',    to: 'static_pages#home'
  get     '/about',   to: 'static_pages#about'
  get     '/help',    to: 'static_pages#help'
  get     '/contact', to: 'static_pages#contact'
  get     '/signup',  to: 'users#new'
  get     '/login',   to: 'sessions#new'
  post    '/login',  to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'

  resources :microposts 
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#home"

  resources :relationships, only: [:create, :destroy]
end
