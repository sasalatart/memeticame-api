Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/fcm_register', to: 'fcm_registrations#register'
  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  resources :users, except: [:show, :new, :create, :edit, :update, :destroy]

  resources :chats, except: [:show, :update, :destroy] do
    member do
      resources :messages, shallow: true, except: [:show, :update, :destroy]
      post '/leave', to: 'chats#leave', as: :leave
      post '/users/:user_id/kick', to: 'chats#kick', as: :kick_user
    end
  end
end
