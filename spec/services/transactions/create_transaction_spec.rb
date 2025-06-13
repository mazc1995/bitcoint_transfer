require 'rails_helper'

RSpec.describe Transactions::CreateTransaction do
  describe '#call' do
    let(:btc_price) { 50_000.0 }

    before do
      allow(Coingecko::FetchPrice).to receive(:new).and_return(double(call: btc_price))
    end

    context 'when the transaction is successful (usd to bitcoin)' do
      let!(:user) { create(:user) }
      let(:transaction_params) { { user_id: user.id, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 100.0 } }

      it 'updates the user balance' do
        expect {
          described_class.new(transaction_params).call
        }.to change { user.reload.balance_usd }.by(-100.0)
         .and change { user.reload.balance_btc }.by(0.002)
      end
    end

    context 'when the transaction is successful (bitcoin to usd)' do
      let!(:user) { create(:user) }
      let(:transaction_params) { { user_id: user.id, from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1 } }

      it 'updates the user balance' do
        expect {
          described_class.new(transaction_params).call
        }.to change { user.reload.balance_btc }.by(-0.1)
         .and change { user.reload.balance_usd }.by(5000.0)
      end
    end

    context 'when the currency pair is invalid' do
      let!(:user) { create(:user) }
      let(:transaction_params) { { user_id: user.id, from_currency: 'usd', to_currency: 'eth', amount_from: 100 } }

      it 'raises an error' do
        expect {
          described_class.new(transaction_params).call
        }.to raise_error(StandardError, 'Invalid currency pair. Only USD to BTC and BTC to USD are supported.')
      end
    end

    context 'when the balance is insufficient' do
      let!(:user) { create(:user, :with_no_balance) }
      let(:transaction_params) { { user_id: user.id, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 100000 } }

      it 'raises an error' do
        expect {
          described_class.new(transaction_params).call
        }.to raise_error(StandardError, 'Insufficient balance')
      end
    end
  end
end
