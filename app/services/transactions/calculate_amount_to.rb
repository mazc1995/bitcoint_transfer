require_relative 'errors'

module Transactions
  class CalculateAmountTo
    def initialize(from_currency:, to_currency:, amount_from:, price:, user_id: nil, transaction_id: nil)
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
      @price = price
      @user_id = user_id
      @transaction_id = transaction_id
    end

    def call
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        @amount_from / @price
      when ['bitcoin', 'usd']
        @amount_from * @price
      else
        raise Transactions::InvalidCalculationPairError.new(user_id: @user_id, transaction_id: @transaction_id)
      end
    end
  end
end 