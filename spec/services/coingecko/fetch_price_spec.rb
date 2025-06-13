require 'rails_helper'

RSpec.describe Coingecko::FetchPrice do
  describe '#call' do
    it 'returns the price of the from currency in the to currency' do
      fetch_price = Coingecko::FetchPrice.new('bitcoin', 'usd')
      fetch_price.call
      expect(fetch_price.result).to be_a(Float)
    end
  end
end