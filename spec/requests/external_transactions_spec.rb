require 'swagger_helper'

RSpec.describe 'ExternalTransactions API', type: :request do
  let!(:user) { create(:user, email: 'user1@example.com', password: 'password123', password_confirmation: 'password123', balance_usd: 100.0) }
  let(:auth_token) do
    post '/api/v1/login', params: { email: user.email, password: 'password123' }
    JSON.parse(response.body)['token']
  end
  let(:headers) { { 'Authorization' => "Bearer #{auth_token}" } }
  let(:user_id) { user.id }

  before(:each) { auth_token }

  path '/api/v1/users/{user_id}/external_transactions' do
    parameter name: :user_id, in: :path, type: :integer, required: true
    post 'Crea una transacción externa (depósito o retiro)' do
      security [Bearer: []]
      tags 'ExternalTransactions'
      consumes 'application/json'
      parameter name: :external_transaction, in: :body, schema: {
        type: :object,
        properties: {
          from_currency: { type: :string, enum: ['external', 'usd'] },
          to_currency: { type: :string, enum: ['usd', 'external'] },
          amount_from: { type: :number, format: :float, example: 50.0 }
        },
        required: ['from_currency', 'to_currency', 'amount_from']
      }

      response '201', 'depósito externo exitoso' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'external', to_currency: 'usd', amount_from: 50 } }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json['from_currency']).to eq('external')
          expect(json['to_currency']).to eq('usd')
          expect(json['amount_from'].to_f).to eq(50.0)
          expect(user.reload.balance_usd).to eq(150.0)
        end
      end

      response '201', 'retiro externo exitoso' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'usd', to_currency: 'external', amount_from: 40 } }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:created)
          json = JSON.parse(response.body)
          expect(json['from_currency']).to eq('usd')
          expect(json['to_currency']).to eq('external')
          expect(json['amount_from'].to_f).to eq(40.0)
          expect(user.reload.balance_usd).to eq(60.0)
        end
      end

      response '422', 'monto cero' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'external', to_currency: 'usd', amount_from: 0 } }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to include(I18n.t('errors.invalid_amount'))
        end
      end

      response '422', 'monto negativo' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'external', to_currency: 'usd', amount_from: -10 } }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to include(I18n.t('errors.invalid_amount'))
        end
      end

      response '422', 'par de monedas inválido' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'usd', to_currency: 'btc', amount_from: 10 } }
        let(:Authorization) { "Bearer #{auth_token}" }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to include(I18n.t('errors.invalid_deposit_currency_pair'))
        end
      end

      response '401', 'requiere autenticación' do
        let(:user_id) { user.id }
        let(:external_transaction) { { from_currency: 'external', to_currency: 'usd', amount_from: 10 } }
        let(:Authorization) { nil }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end 