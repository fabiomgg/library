Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :books do
    resources :borrowings, only: [:create] do
      post 'return', on: :collection
    end
  end
  get 'dashboard', to: 'dashboard#show', as: 'dashboard'
  get '/error', to: 'errors#unauthorized', as: 'error'
end
