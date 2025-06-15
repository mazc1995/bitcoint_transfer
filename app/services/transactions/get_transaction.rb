module Transactions
  class GetTransaction
    attr_reader :id, :user_id

    # @param params [Hash]
    # @option params [Integer] :id
    # @option params [Integer] :user_id
    def initialize(params)
      @id = params[:id]
      @user_id = params[:user_id].to_i
    end

    # @return [Transaction]
    def call
      begin
        transaction = Transaction.find(id)
      rescue ActiveRecord::RecordNotFound
        raise Transactions::Errors::TransactionNotFoundError.new(transaction_id: id, user_id: user_id)
      end
      if transaction.user_id != user_id
        raise Transactions::Errors::TransactionNotFoundError.new(transaction_id: id, user_id: user_id)
      end
      transaction
    end
  end
end
