module ExternalTransactions
  class CreateTransaction < ApplicationService
    attr_reader :from_currency, :to_currency, :amount_from, :amount_to, :user, :price, :transaction

    # @param transaction_params [Hash]
    # @option transaction_params [Integer] :user_id
    # @option transaction_params [String] :from_currency (usd, external)
    # @option transaction_params [String] :to_currency (usd, external)
    # @option transaction_params [Float] :amount_from (amount of currency to convert)
    def initialize(transaction_params)
      @from_currency = transaction_params[:from_currency]
      @to_currency = transaction_params[:to_currency]
      @amount_from = transaction_params[:amount_from].to_f
      @user = User.find(transaction_params[:user_id])
    end

    # @return [Transaction]
    def call
      validate_transaction
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

    # @return [void]
    def validate_transaction
      ExternalTransactions::ValidateTransaction.new(
        user: user,
        from_currency: from_currency,
        to_currency: to_currency,
        amount_from: amount_from
      ).call
    end

    # @return [Float]
    def calculate_amount_to
      @amount_to = amount_from
    end

    # @return [Transaction]
    def complete_transaction
      transaction.update!(
        status: :completed
      )
    end

    # @return [void]
    def update_user_balance
      ExternalTransactions::UpdateUserBalance.new(
        user: user,
        from_currency: from_currency,
        to_currency: to_currency,
        amount_from: amount_from,
        amount_to: amount_to,
        transaction_id: transaction&.id
      ).call
    end

    # @return [Transaction]
    def create_transaction
      @transaction = Transaction.create!(
        user: user,
        from_currency: from_currency,
        to_currency: to_currency,
        amount_from: amount_from,
        amount_to: amount_to,
        price_reference: 1,
        status: :pending
      )
    end
  end
end