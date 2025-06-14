require 'swagger_helper'

RSpec.describe 'Transactions API', type: :request do
  let(:user) { create(:user) }

  path '/api/v1/users/{user_id}/transactions' do
    parameter name: :user_id, in: :path, type: :integer, required: true

    post 'Creates a transaction' do
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

        before do
          allow(Coingecko::FetchPrice).to receive(:new).and_return(double(call: 50000.0))
        end

        run_test! do |response|
          expect(response).to have_http_status(:created)
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

        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/transactions/{id}' do
    parameter name: :user_id, in: :path, type: :integer, required: true
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Gets a transaction' do
      tags 'Transactions'
      response '200', 'transaction found' do
        let(:user_id) { user.id }
        let!(:transaction) { create(:transaction, user:) }
        let(:id) { transaction.id }
        run_test!
      end

      response '404', 'transaction not found' do
        let(:user_id) { user.id }
        let(:id) { 999 }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          json = JSON.parse(response.body)
          expect(json['status']).to eq(404)
          expect(json['error']).to match(/Transaction not found.*transaction_id: 999.*user_id: #{user.id}/)
        end
      end

      response '404', 'transaction not found for wrong user' do
        let(:other_user) { create(:user) }
        let!(:transaction) { create(:transaction, user: other_user) }
        let(:user_id) { user.id }
        let(:id) { transaction.id }
        run_test! do |response|
          expect(response).to have_http_status(:not_found)
          json = JSON.parse(response.body)
          expect(json['status']).to eq(404)
          expect(json['error']).to match(/Transaction not found.*transaction_id: #{id}.*user_id: #{user.id}/)
        end
      end
    end
  end

  path '/api/v1/users/{user_id}/transactions' do
    parameter name: :user_id, in: :path, type: :integer, required: true

    get 'Gets all transactions' do
      tags 'Transactions'
      response '200', 'transactions found' do
        let(:user_id) { user.id }
        let!(:transaction) { create_list(:transaction, 3, user:) }
        run_test!
      end
    end
  end
end
