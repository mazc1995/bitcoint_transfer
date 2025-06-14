module Transactions
  class CalculateAmountTo
    def initialize(from_currency:, to_currency:, amount_from:, price:)
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
      @price = price
    end

    def call
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        @amount_from / @price
      when ['bitcoin', 'usd']
        @amount_from * @price
      else
        raise StandardError, 'Invalid currency pair for calculation'
      end
    end
  end
end 