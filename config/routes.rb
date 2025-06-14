Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :transactions, only: [:index, :create, :show]
      end
      get 'currencies/btc_price', to: 'currencies#btc_price'
    end
  end
end
