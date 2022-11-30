Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :poker_tables, only: %i[index show] do
    resources :players, only: [:create]
  end
  resources :players, only: [] do
    patch :leave, on: :member
  end
  resources :player_hands, only: [] do
    member do
      patch :call_hand
      patch :raise_hand
      patch :fold_hand
    end
  end
  resources :table_hands, only: [:create] do
    patch :reinitialize, on: :member, as: "reinitialize"
    patch :flop
    patch :turn
    patch :river
  end
end
