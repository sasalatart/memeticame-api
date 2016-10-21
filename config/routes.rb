Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/fcm_register', to: 'fcm_registrations#register'
  post '/users', to: 'users#index'
  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'

  resources :chats, except: [:update, :destroy] do
    member do
      resources :messages, shallow: true, except: [:show, :update, :destroy]
      post '/leave', to: 'chats#leave'
      post '/users/:user_id/kick', to: 'chats#kick', as: :kick_user
      post '/invite', to: 'chats#invite'
      get '/invitations', to: 'chats#invitations'
    end
  end

  resources :chat_invitations, only: [:index] do
    member do
      post '/accept', to: 'chat_invitations#accept'
      post '/reject', to: 'chat_invitations#reject'
    end
  end
end
