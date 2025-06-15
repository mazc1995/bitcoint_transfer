module ExternalTransactions
  module Errors
    class InvalidCurrencyPairError < StandardError
      attr_reader :user_id, :transaction_id

      # @param msg [String]
      # @param user_id [Integer]
      # @param transaction_id [Integer]
      def initialize(msg = nil, user_id: nil, transaction_id: nil)
        @user_id = user_id
        @transaction_id = transaction_id
        msg ||= I18n.t('errors.invalid_deposit_currency_pair')
        super("#{msg} | user_id: #{user_id} | transaction_id: #{transaction_id}")
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