Rails.application.routes.draw do
    get "/auth/:provider/callback" => "sessions#create"
    get 'auth/failure', to: redirect('/')
    get 'signout', to: 'sessions#destroy', as: 'signout'
    resources :users
    resources :sessions, only: [:create, :destroy]
    resource :home, only: [:index]
    resources :restaurants do
      collection do
        get 'search' => 'restaurants#search', as: 'search'
      end
      resources :foods
    end

  root to: "home#index"
end
# Rails.application.routes.draw do
#   get 'sessions/create'
#   get 'sessions/destroy'
#   root 'home#index'
#   resources :restaurants do
#     collection do
#       get 'search' => 'restaurants#search', as: 'search'
#     end
#     resources :foods
#   end
#   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
# end
