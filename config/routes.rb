Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'
  resources :users, except: [:new, :create, :edit, :update]
  resources :chats
end
