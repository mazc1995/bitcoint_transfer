module ErrorHandlerConcern
  extend ActiveSupport::Concern

  included do
    rescue_from Transactions::Errors::TransactionNotFoundError do |e|
      render json: { status: 404, error: e.message }, status: :not_found
    end

    rescue_from Transactions::Errors::InvalidCurrencyPairError do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    rescue_from Transactions::Errors::InvalidAmountError do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    rescue_from ExternalTransactions::Errors::InvalidAmountError do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    rescue_from ExternalTransactions::Errors::InvalidCurrencyPairError do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end