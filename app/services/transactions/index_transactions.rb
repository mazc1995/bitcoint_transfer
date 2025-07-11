module Transactions
  class IndexTransactions < ApplicationService
    attr_reader :user_id

    # @param params [Hash]
    # @option params [Integer] :user_id
    def initialize(params)
      @user_id = params[:user_id]
    end

    # @return [Array<Transaction>]
    def call
      Transaction.where(user_id: user_id)
    end
  end
end