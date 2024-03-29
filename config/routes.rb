Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/fcm_register', to: 'fcm_registrations#register'
  post '/users', to: 'users#index'
  get '/users/:phone_number', to: 'users#show'
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

  resources :plain_memes, only: [:index]
  resources :channels, only: [:index, :show, :create] do
    resources :categories, shallow: true, only: [] do
      resources :memes, shallow: true, only: [:create] do
        get '/my_rating', to: 'ratings#my_rating'
        resources :ratings, shallow: true, only: [:create]
      end
    end
  end

  post '/search_memes', to: 'memes#search'
  post '/recognize', to: 'emotions#recognize'
end
