require 'swagger_helper'

RSpec.describe 'Transactions API', type: :request do
  let!(:user) { create(:user, email: 'user1@example.com', password: 'password123', password_confirmation: 'password123') }
  let(:auth_token) do
    post '/api/v1/login', params: { email: user.email, password: 'password123' }
    JSON.parse(response.body)['token']
  end
  let(:Authorization) { "Bearer #{auth_token}" }

  before(:each) do
    # Forzar login antes de cada request
    auth_token
  end

  path '/api/v1/users/{user_id}/transactions' do
    parameter name: :user_id, in: :path, type: :integer, required: true

    post 'Creates a transaction' do
      security [Bearer: []]
      tags 'Transactions'
      consumes 'application/json'
      parameter name: :transaction, in: :body, schema: {
        type: :object,
        properties: {
          from_currency: { type: :string, enum: ['usd', 'bitcoin'] },
          to_currency: { type: :string, enum: ['bitcoin', 'usd'] },
          amount_from: { type: :number, format: :float, default: 50.0 }
        },
        required: ['from_currency', 'to_currency', 'amount_from']
      }

      response '201', 'transaction created' do
        let(:user_id) { user.id }
        let(:transaction) do
          {
            from_currency: 'usd',
            to_currency: 'bitcoin',
            amount_from: 100.0
          }
        end
        let(:Authorization) { "Bearer #{auth_token}" }

        before do
          allow(Coingecko::FetchPrice).to receive(:new).and_return(double(call: 50000.0))
        end

        run_test! do |response|
          expect(response).to have_http_status(:created), "Response body: \\n#{response.body}"
          json_response = JSON.parse(response.body)
          expect(json_response['from_currency']).to eq('usd')
          expect(json_response['to_currency']).to eq('bitcoin')
          expect(json_response['amount_from'].to_f).to eq(100.0)
          expect(json_response['amount_to']).to be_present
        end
      end

      response '422', 'invalid request' do
        let(:user_id) { user.id }
        let(:transaction) do
          {
            from_currency: 'usd',
            to_currency: 'usd',
            amount_from: 100.0
          }
        end
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity), "Response body: \\n#{response.body}"
        end
      end

      response '401', 'unauthorized when no token' do
        let(:user_id) { user.id }
        let(:transaction) do
          {
            from_currency: 'usd',
            to_currency: 'bitcoin',
            amount_from: 100.0
          }
        end
        let(:Authorization) { nil }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Unauthorized')
        end
      end

      response '403', 'forbidden for other user' do
        let(:other_user) { create(:user, email: 'otheruser@example.com', password: 'password123', password_confirmation: 'password123') }
        let(:user_id) { other_user.id }
        let(:transaction) do
          {
            from_currency: 'usd',
            to_currency: 'bitcoin',
            amount_from: 100.0
          }
        end
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:forbidden)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Forbidden')
        end
      end
    end

    get 'Gets all transactions' do
      security [Bearer: []]
      tags 'Transactions'
      response '200', 'transactions found' do
        let(:user_id) { user.id }
        let!(:transaction) { create_list(:transaction, 3, user: user) }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:ok), "Response body: \\n#{response.body}"
        end
      end
    end
  end

  path '/api/v1/users/{user_id}/transactions/{id}' do
    parameter name: :user_id, in: :path, type: :integer, required: true
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Gets a transaction' do
      security [Bearer: []]
      tags 'Transactions'
      response '200', 'transaction found' do
        let(:user_id) { user.id }
        let!(:transaction) { create(:transaction, user: user) }
        let(:id) { transaction.id }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:ok), "Response body: \\n#{response.body}"
        end
      end

      response '404', 'transaction not found' do
        let(:user_id) { user.id }
        let(:id) { 999 }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:not_found), "Response body: \\n#{response.body}"
          json = JSON.parse(response.body)
          expect(json['status']).to eq(404)
          expect(json['error']).to match(/Transaction not found.*transaction_id: 999.*user_id: #{user.id}/)
        end
      end

      response '404', 'transaction not found for wrong user' do
        let(:other_user) { create(:user, email: 'other@example.com', password: 'password123', password_confirmation: 'password123') }
        let!(:transaction) { create(:transaction, user: other_user) }
        let(:user_id) { user.id }
        let(:id) { transaction.id }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:not_found), "Response body: \\n#{response.body}"
          json = JSON.parse(response.body)
          expect(json['status']).to eq(404)
          expect(json['error']).to match(/Transaction not found.*transaction_id: #{id}.*user_id: #{user.id}/)
        end
      end
    end
  end
end
