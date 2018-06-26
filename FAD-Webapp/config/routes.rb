Rails.application.routes.draw do
  root 'home#index'
  resources :restaurants do
    resources :food
    get :search, :action => 'search'
    # get "restaurants/search" => "restaurants#search", as: search_restaurants
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
