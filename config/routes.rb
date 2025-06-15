Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :transactions, only: [:index, :create, :show]
        post 'external_transactions', to: 'transactions#create_external_transaction'
      end
      get 'currencies/btc_price', to: 'currencies#btc_price'
      post 'register', to: 'auth#register'
      post 'login', to: 'auth#login'
      resources :transactions, only: [:index, :show, :create]
    end
  end

  get '/coverage', to: redirect('/coverage/index.html')

  root to: redirect('/api-docs')
end
