module Transactions
  class ValidateTransaction < ApplicationService
    ALLOWED_CURRENCY_TRANSACTIONS = [['usd', 'bitcoin'], ['bitcoin', 'usd']].freeze

    # @param user [User]
    # @param from_currency [String]
    # @param to_currency [String]
    # @param amount_from [Float]
    def initialize(user:, from_currency:, to_currency:, amount_from:)
      @user = user
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
    end

    # @return [void]
    def call
      validate_currency_pair!
      validate_balance!
    end

    private

    # @return [void]
    def validate_currency_pair!
      unless [@from_currency, @to_currency].in?(ALLOWED_CURRENCY_TRANSACTIONS)
        raise Transactions::Errors::InvalidCurrencyPairError.new(user_id: @user.id)
      end
    end

    # @return [void]
    def validate_balance!
      required_amount = @amount_from
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        raise Transactions::Errors::InsufficientBalanceError.new(user_id: @user.id) if @user.balance_usd < required_amount
      when ['bitcoin', 'usd']
        raise Transactions::Errors::InsufficientBalanceError.new(user_id: @user.id) if @user.balance_btc < required_amount
      end
    end
  end
end 