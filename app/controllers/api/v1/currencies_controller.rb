module Api::V1
  class CurrenciesController < ApplicationController

    def btc_price
      @btc_price = Coingecko::FetchPrice.new.call
      render json: { usd_btc_price: @btc_price }, status: :ok
    end
  end
end