module Transactions
  class UpdateUserBalance < ApplicationService
    # @param user [User]
    # @param from_currency [String]
    # @param to_currency [String]
    # @param amount_from [Float]
    # @param amount_to [Float]
    # @param transaction_id [Integer]
    def initialize(user:, from_currency:, to_currency:, amount_from:, amount_to:, transaction_id: nil)
      @user = user
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
      @amount_to = amount_to
      @transaction_id = transaction_id
    end

    # @return [void]
    def call
      case [@from_currency, @to_currency]
      when ['usd', 'bitcoin']
        @user.update!(
          balance_usd: @user.balance_usd - @amount_from,
          balance_btc: @user.balance_btc + @amount_to
        )
      when ['bitcoin', 'usd']
        @user.update!(
          balance_usd: @user.balance_usd + @amount_to,
          balance_btc: @user.balance_btc - @amount_from
        )
      else
        raise Transactions::Errors::InvalidBalanceUpdatePairError.new(user_id: @user.id, transaction_id: @transaction_id)
      end
    end
  end
end 