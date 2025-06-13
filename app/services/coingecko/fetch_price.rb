module Coingecko
  class FetchPrice
    attr_reader :from_currency, :to_currency, :result

    # [String] the url of the coingecko api
    URL = "https://api.coingecko.com/api/v3/simple/price"

    # @param from_currency [String] bitcoin
    # @param to_currency [String] usd
    def initialize
      @from_currency = "bitcoin"
      @to_currency = "usd"
    end

    # @return [Float] the price of bitcoin in usd
    def call
      response = HTTParty.get(URL, query: { ids: from_currency, vs_currencies: to_currency })
      @result = response.parsed_response[from_currency][to_currency].to_f
    end
  end
end