module Transactions
  module Errors
    class InvalidCurrencyPairError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.invalid_currency_pair')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InsufficientBalanceError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.insufficient_balance')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InvalidCalculationPairError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.invalid_calculation_pair')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InvalidBalanceUpdatePairError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.invalid_balance_update_pair')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class TransactionNotFoundError < StandardError
      attr_reader :transaction_id, :user_id

      # @param msg [String]
      # @param transaction_id [Integer]
      # @param user_id [Integer]
      def initialize(msg = nil, transaction_id: nil, user_id: nil)
        @transaction_id = transaction_id
        @user_id = user_id
        msg ||= I18n.t('errors.transaction_not_found')
        super("#{msg} | transaction_id: #{transaction_id} | user_id: #{user_id}")
      end
    end

    class InvalidAmountError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.invalid_amount')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end
  end
end