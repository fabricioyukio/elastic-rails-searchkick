Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Defines the root path route ("/")
  root 'page#home'

  get 'search', to: 'search#search'

  get 'about', to: 'page#about'

  resources :prompts, :only => [:show, :new, :create, :edit, :update, :destroy]
end
