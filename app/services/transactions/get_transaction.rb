module Transactions
  class GetTransaction
    attr_reader :id, :user_id

    def initialize(params)
      @id = params[:id]
      @user_id = params[:user_id].to_i
    end

    def call
      transaction = Transaction.find(id)
      raise StandardError, 'Transaction not found' if transaction.user_id != user_id
      transaction
    end
  end
end
