module Auth
  class RegisterUser < ApplicationService
    Result = Struct.new(:user, :token, :errors, keyword_init: true) do
      # @return [Boolean]
      def success?
        user.present? && errors.blank?
      end

      # @return [Hash]
      def user_response
        user&.as_json(only: [:id, :name, :email, :balance_usd, :balance_btc])
      end
    end

    # @param params [Hash]
    # @option params [String] :name
    # @option params [String] :email
    # @option params [String] :password
    # @option params [String] :password_confirmation
    def initialize(params)
      @params = params.merge(balance_usd: 0, balance_btc: 0)
    end

    # @return [Result]
    def call
      user = User.new(@params)
      if user.save
        token = encode_token(user_id: user.id)
        Result.new(user: user, token: token, errors: nil)
      else
        Result.new(user: nil, token: nil, errors: user.errors.full_messages)
      end
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end
  end
end 