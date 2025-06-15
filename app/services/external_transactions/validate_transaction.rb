module ExternalTransactions
  class ValidateTransaction < ApplicationService
    ALLOWED_CURRENCY_TRANSACTIONS = [['usd', 'external'], ['external', 'usd']].freeze

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
      validate_amount!
      validate_user_balance!
    end

    private

    # @return [void]
    def validate_currency_pair!
      unless [@from_currency, @to_currency].in?(ALLOWED_CURRENCY_TRANSACTIONS)
        raise ExternalTransactions::Errors::InvalidCurrencyPairError.new(user_id: @user.id)
      end
    end

    # @return [void]
    def validate_amount!
      if @amount_from <= 0
        raise ExternalTransactions::Errors::InvalidAmountError.new(user_id: @user.id)
      end
    end

    # @return [void]
    def validate_user_balance!
      case [@from_currency, @to_currency]
      when ['usd', 'external']
        if @user.balance_usd < @amount_from
          raise ExternalTransactions::Errors::InsufficientBalanceError.new(user_id: @user.id)
        end
      end
    end
  end
end 