Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'page#home'

  get 'search', to: 'search#search'

  get 'about', to: 'pages#about'

  resources :prompts
end
