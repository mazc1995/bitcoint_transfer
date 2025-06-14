require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/api/v1/register' do
    post 'Register a new user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John Doe' },
          email: { type: :string, example: 'john.doe@example.com' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' },
        },
        required: ['name', 'email', 'password', 'password_confirmation']
      }

      response '201', 'user created' do
        let(:user) do
          {
            name: 'Test User',
            email: "testuser_#{SecureRandom.hex(8)}@example.com",
            password: 'password123',
            password_confirmation: 'password123',
            balance_usd: 0,
            balance_btc: 0
          }
        end
        let(:raw_post) { user.to_json }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: '', email: '', password: '', password_confirmation: '' } }
        let(:raw_post) { user.to_json }
        run_test!
      end

      response '422', 'email already taken' do
        let!(:existing_user) { create(:user, email: 'duplicate@example.com') }
        let(:user) { { name: 'Test', email: 'duplicate@example.com', password: 'password123', password_confirmation: 'password123' } }
        let(:raw_post) { user.to_json }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          json = JSON.parse(response.body)
          expect(json['errors']).to include('Email has already been taken')
        end
      end
    end
  end

  path '/api/v1/login' do
    post 'Login a user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'john.doe@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'login successful' do
        let!(:user) { create(:user, email: 'login@example.com', password: 'password123', password_confirmation: 'password123', balance_usd: 1000, balance_btc: 0.5) }
        let(:credentials) { { email: 'login@example.com', password: 'password123' } }
        let(:raw_post) { credentials.to_json }
        run_test!
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'login@example.com', password: 'wrongpass' } }
        let(:raw_post) { credentials.to_json }
        run_test!
      end

      response '401', 'login with non-existent email' do
        let(:credentials) { { email: 'noexiste@example.com', password: 'password123' } }
        let(:raw_post) { credentials.to_json }
        run_test! do |response|
          expect(response).to have_http_status(:unauthorized)
          json = JSON.parse(response.body)
          expect(json['error']).to eq('Invalid email or password')
        end
      end
    end
  end
end 