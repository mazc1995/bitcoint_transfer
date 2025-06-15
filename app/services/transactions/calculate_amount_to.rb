module Transactions
  class CalculateAmountTo
    # @param from_currency [String]
    # @param to_currency [String]
    # @param amount_from [Float]
    # @param price [Float]
    # @param user_id [Integer]
    # @param transaction_id [Integer]
    def initialize(from_currency:, to_currency:, amount_from:, price:, user_id: nil, transaction_id: nil)
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
      @price = price
      @user_id = user_id
      @transaction_id = transaction_id
    end

    # @return [Float]
    def call
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        @amount_from / @price
      when ['bitcoin', 'usd']
        @amount_from * @price
      else
        raise Transactions::Errors::InvalidCalculationPairError.new(user_id: @user_id, transaction_id: @transaction_id)
      end
    end
  end
end 