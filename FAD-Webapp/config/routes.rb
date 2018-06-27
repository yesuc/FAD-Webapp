Rails.application.routes.draw do
  root 'home#index'
  resources :restaurants do
    collection do
      get 'search' => 'restaurants#search', as: 'search'
    end
    resources :food
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
