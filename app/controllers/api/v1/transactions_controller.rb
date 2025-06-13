module Api::V1
  class TransactionsController < ApplicationController

    def show
      @transaction = Transactions::GetTransaction.new(show_params).call
      render json: @transaction, status: :ok
    end

    def create
      @transaction = Transactions::CreateTransaction.new(transaction_params).call
      render json: @transaction, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def show_params
      params.permit(:id, :user_id)
    end

    def transaction_params
      params.permit(:from_currency, :to_currency, :amount_from, :user_id)
    end
  end
end
