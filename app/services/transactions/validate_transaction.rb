require_relative 'errors'

module Transactions
  class ValidateTransaction
    ALLOWED_CURRENCY_TRANSACTIONS = [['usd', 'bitcoin'], ['bitcoin', 'usd']].freeze

    def initialize(user:, from_currency:, to_currency:, amount_from:)
      @user = user
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
    end

    def call
      validate_currency_pair!
      validate_balance!
    end

    private

    def validate_currency_pair!
      unless [@from_currency, @to_currency].in?(ALLOWED_CURRENCY_TRANSACTIONS)
        raise Transactions::InvalidCurrencyPairError.new(user_id: @user.id)
      end
    end

    def validate_balance!
      required_amount = @amount_from
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        raise Transactions::InsufficientBalanceError.new(user_id: @user.id) if @user.balance_usd < required_amount
      when ['bitcoin', 'usd']
        raise Transactions::InsufficientBalanceError.new(user_id: @user.id) if @user.balance_btc < required_amount
      end
    end
  end
end 