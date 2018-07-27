Rails.application.routes.draw do
  root "home#index"
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks",
    sessions: 'users/sessions',
     registrations: 'users/registrations'}
  resources :restaurants do
    collection do
      get 'search' => 'restaurants#search', as: 'search'
    end
    resources :foods
  end
  resources :users
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
