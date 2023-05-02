Rails.application.routes.draw do
  resources :searches
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'page#home'

  get 'about', to: 'pages#about'

  resources :prompts

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
