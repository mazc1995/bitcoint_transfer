module Transactions
  class UpdateUserBalance
    def initialize(user:, from_currency:, to_currency:, amount_from:, amount_to:)
      @user = user
      @from_currency = from_currency
      @to_currency = to_currency
      @amount_from = amount_from
      @amount_to = amount_to
    end

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
        raise StandardError, 'Invalid currency pair for balance update'
      end
    end
  end
end 