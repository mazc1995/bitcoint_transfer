module Api::V1
  class TransactionsController < ApplicationController
    before_action :authenticate_user!

    def index
      authorize User.find(params[:user_id]), :index_transactions?
      @transactions = Transactions::IndexTransactions.new(index_params).call
      render json: @transactions, each_serializer: TransactionSerializer, status: :ok
    end

    def show
      authorize User.find(params[:user_id]), :show_transaction?
      @transaction = Transactions::GetTransaction.new(show_params).call
      render json: @transaction, serializer: TransactionSerializer, status: :ok
    end

    def create
      authorize User.find(params[:user_id]), :create_transaction?
      @transaction = Transactions::CreateTransaction.new(transaction_params).call
      render json: @transaction, serializer: TransactionSerializer, status: :created
    end

    rescue_from Transactions::TransactionNotFoundError do |e|
      render json: { status: 404, error: e.message }, status: :not_found
    end

    rescue_from Transactions::InvalidCurrencyPairError do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def index_params
      { user_id: current_user.id }
    end

    def show_params
      { id: params[:id], user_id: current_user.id }
    end

    def transaction_params
      params.permit(:from_currency, :to_currency, :amount_from, :user_id)
    end
  end
end
