require 'swagger_helper'

RSpec.describe 'Currencies', type: :request do
  path '/api/v1/currencies/btc_price' do
    get 'Gets the price of BTC' do
      tags 'Currencies'
      response '200', 'price fetched' do
        before do
          allow(Coingecko::FetchPrice).to receive(:new).and_return(double(call: 50000.0))
        end
        run_test! do |response|
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['usd_btc_price']).to eq(50000.0)
        end
      end
      response '502', 'coingecko error' do
        before do
          allow(Coingecko::FetchPrice).to receive(:new).and_raise(StandardError, "API error")
        end
        run_test! do |response|
          expect(response).to have_http_status(:bad_gateway)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Error fetching BTC price')
        end
      end
    end
  end
end