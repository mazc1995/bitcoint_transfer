module Transactions
  class CreateTransaction
    attr_reader :from_currency, :to_currency, :amount_from, :amount_to, :user, :price, :transaction

    # [Array] the allowed currency transactions
    ALLOWED_CURRENCY_TRANSACTIONS = [['usd', 'bitcoin'], ['bitcoin', 'usd']].freeze

    # @param transaction_params [Hash]
    # @option transaction_params [Integer] :user_id
    # @option transaction_params [String] :from_currency (usd, bitcoin)
    # @option transaction_params [String] :to_currency (usd, bitcoin)
    # @option transaction_params [Float] :amount_from (amount of currency to convert)
    def initialize(transaction_params)
      @from_currency = transaction_params[:from_currency]
      @to_currency = transaction_params[:to_currency]
      @amount_from = transaction_params[:amount_from]
      @user = User.find(transaction_params[:user_id])
    end

    # @return [Transaction]
    def call
      validate_currency_pair!
      validate_balance!
      fetch_price
      calculate_amount_to
      create_transaction

      ActiveRecord::Base.transaction do
        update_user_balance
        complete_transaction
      end

      transaction
    rescue StandardError => e
      transaction&.update!(status: :failed)
      raise e
    end

    private

    # @return [Transaction]
    def create_transaction
      @transaction = Transaction.create!(
        user: user,
        from_currency: from_currency,
        to_currency: to_currency,
        amount_from: amount_from,
        amount_to: amount_to,
        price_reference: price,
        status: :pending
      )
    end

    # @return [Float]
    def fetch_price
      @price = Coingecko::FetchPrice.new.call
    end

    # @return [void]
    def validate_currency_pair!
      raise_invalid_currency_pair! unless currency_pair.in?(ALLOWED_CURRENCY_TRANSACTIONS)
    end

    # @return [Array]
    def currency_pair
      [from_currency, to_currency]
    end

    # @return [Float]
    def calculate_amount_to
      case currency_pair
      when ['usd', 'bitcoin'] then @amount_to = amount_from / price
      when ['bitcoin', 'usd'] then @amount_to = amount_from * price
      end
    end

    # @return [void]
    # @raise [StandardError] if the balance is insufficient
    # @raise [StandardError] if the currency pair is invalid (usd to bitcoin or bitcoin to usd)
    def validate_balance!
      required_amount = amount_from

      case currency_pair
      when ['usd', 'bitcoin']
        raise_insufficient_balance! if user.balance_usd < required_amount
      when ['bitcoin', 'usd']
        raise_insufficient_balance! if user.balance_btc < required_amount
      end
    end

    # @return [void]
    def complete_transaction
      transaction.update!(
        status: :completed
      )
    end

    # @return [void]
    # @raise [StandardError] if the currency pair is invalid (usd to bitcoin or bitcoin to usd)
    def update_user_balance
      case currency_pair
      when ['usd', 'bitcoin']
        user.update!(
          balance_usd: user.balance_usd - amount_from,
          balance_btc: user.balance_btc + amount_to
        )
      when ['bitcoin', 'usd']
        user.update!(
          balance_usd: user.balance_usd + amount_to,
          balance_btc: user.balance_btc - amount_from
        )
      end
    end

    # @raise [StandardError] if the balance is insufficient
    def raise_insufficient_balance!
      raise StandardError, "Insufficient balance"
    end

    # @raise [StandardError] if the currency pair is invalid (usd to bitcoin or bitcoin to usd)
    def raise_invalid_currency_pair!
      raise StandardError, "Invalid currency pair. Only USD to BTC and BTC to USD are supported."
    end
  end
end