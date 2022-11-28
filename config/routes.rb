Rails.application.routes.draw do
  get 'table_hands/start'
  get 'player_hands/call_hand'
  get 'player_hands/raise_hand'
  get 'player_hands/fold_hand'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :poker_tables, only: %i[index show] do
    resources :players, only: [:create]
    patch 'players/:id/leave', to: 'players#leave'
  end
  patch 'player_hands/:id/call_hand', to: 'player_hands#call_hand'
  patch 'player_hands/:id/raise_hand', to: 'player_hands#raise_hand'
  patch 'player_hands/:id/fold_hand', to: 'player_hands#fold_hand'
  patch 'table_hands/:id/start', to: 'table_hands#start'
end
