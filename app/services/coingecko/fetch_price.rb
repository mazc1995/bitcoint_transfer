module Coingecko
  class FetchPrice
    attr_reader :from_currency, :to_currency, :result

    # [String] the url of the coingecko api
    URL = "https://api.coingecko.com/api/v3/simple/price"

    # @return [void]
    def initialize
      @from_currency = "bitcoin"
      @to_currency = "usd"
    end

    # @return [Float] the price of bitcoin in usd
    # @raise [StandardError] if the response is not valid
    def call
      response = HTTParty.get(URL, query: { ids: from_currency, vs_currencies: to_currency })
      @result = response.parsed_response[from_currency][to_currency].to_f
    end
  end
end