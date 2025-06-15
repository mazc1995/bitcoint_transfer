module Api::V1
  class CurrenciesController < ApplicationController

    # GET /api/v1/currencies/btc_price
    def btc_price
      btc_price = Coingecko::FetchPrice.new.call
      render json: { usd_btc_price: btc_price }, status: :ok
    rescue StandardError
      render json: { error: I18n.t('errors.error_fetching_btc_price') }, status: :bad_gateway
    end
  end
end