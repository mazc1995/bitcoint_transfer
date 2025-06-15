require 'rails_helper'

describe ExternalTransactions::CreateTransaction do
  let(:user) { create(:user, balance_usd: 100.0) }

  context 'when depositing usd from external' do
    it 'increases user balance and creates a completed transaction' do
      params = { user_id: user.id, from_currency: 'external', to_currency: 'usd', amount_from: 50 }
      transaction = described_class.new(params).call
      expect(user.reload.balance_usd).to eq(150.0)
      expect(transaction).to be_persisted
      expect(transaction.status).to eq('completed')
      expect(transaction.from_currency).to eq('external')
      expect(transaction.to_currency).to eq('usd')
      expect(transaction.amount_from.to_f).to eq(50.0)
    end
  end

  context 'when withdrawing usd to external' do
    it 'decreases user balance and creates a completed transaction' do
      params = { user_id: user.id, from_currency: 'usd', to_currency: 'external', amount_from: 40 }
      transaction = described_class.new(params).call
      expect(user.reload.balance_usd).to eq(60.0)
      expect(transaction).to be_persisted
      expect(transaction.status).to eq('completed')
      expect(transaction.from_currency).to eq('usd')
      expect(transaction.to_currency).to eq('external')
      expect(transaction.amount_from.to_f).to eq(40.0)
    end
  end

  context 'when amount is zero or negative' do
    it 'raises InvalidAmountError for zero' do
      params = { user_id: user.id, from_currency: 'external', to_currency: 'usd', amount_from: 0 }
      expect {
        described_class.new(params).call
      }.to raise_error(ExternalTransactions::Errors::InvalidAmountError, include(I18n.t('errors.invalid_amount')))
    end
    it 'raises InvalidAmountError for negative' do
      params = { user_id: user.id, from_currency: 'external', to_currency: 'usd', amount_from: -10 }
      expect {
        described_class.new(params).call
      }.to raise_error(ExternalTransactions::Errors::InvalidAmountError, include(I18n.t('errors.invalid_amount')))
    end
  end

  context 'when currency pair is invalid' do
    it 'raises InvalidCurrencyPairError' do
      params = { user_id: user.id, from_currency: 'usd', to_currency: 'btc', amount_from: 10 }
      expect {
        described_class.new(params).call
      }.to raise_error(ExternalTransactions::Errors::InvalidCurrencyPairError, include(I18n.t('errors.invalid_deposit_currency_pair')))
    end
  end
end 