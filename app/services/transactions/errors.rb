module Transactions
  module Errors
    class InvalidCurrencyPairError < StandardError
      attr_reader :user_id, :transaction_id

      def initialize(msg = "Invalid currency pair. Only USD to BTC and BTC to USD are supported.", user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InsufficientBalanceError < StandardError
      attr_reader :user_id, :transaction_id

      def initialize(msg = "Insufficient balance", user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InvalidCalculationPairError < StandardError
      attr_reader :user_id, :transaction_id

      def initialize(msg = "Invalid currency pair for calculation", user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class InvalidBalanceUpdatePairError < StandardError
      attr_reader :user_id, :transaction_id

      def initialize(msg = "Invalid currency pair for balance update", user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
      end
    end

    class TransactionNotFoundError < StandardError
      attr_reader :transaction_id, :user_id

      def initialize(msg = "Transaction not found", transaction_id: nil, user_id: nil)
        @transaction_id = transaction_id
        @user_id = user_id
        super("#{msg} | transaction_id: #{transaction_id} | user_id: #{user_id}")
      end
    end
  end
end