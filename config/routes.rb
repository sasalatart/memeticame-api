Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/fcm_register', to: 'fcm_registrations#register'
  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  resources :users, except: [:new, :create, :edit, :update]

  resources :chats do
    member do
      resources :messages, shallow: true
      post '/leave', to: 'chats#leave'
    end
  end
end
