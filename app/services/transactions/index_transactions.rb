module Transactions
  class IndexTransactions
    attr_reader :user_id

    def initialize(params)
      @user_id = params[:user_id]
    end

    def call
      Transaction.where(user_id: user_id)
    end
  end
end