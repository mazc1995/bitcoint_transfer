module Auth
  class LoginUser
    Result = Struct.new(:user, :token, :error, keyword_init: true) do
      def success?
        user.present? && error.blank?
      end
      def user_response
        user&.as_json(only: [:id, :name, :email, :balance_usd, :balance_btc])
      end
    end

    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      user = User.find_by(email: @email)
      if user&.authenticate(@password)
        token = encode_token(user_id: user.id)
        Result.new(user: user, token: token, error: nil)
      else
        Result.new(user: nil, token: nil, error: 'Invalid email or password')
      end
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.secret_key_base)
    end
  end
end 