require 'rails_helper'

RSpec.describe Transactions::ValidateTransaction do
  let(:user) { create(:user) }

  context 'when the currency pair is valid' do
    it 'does not raise error for usd to bitcoin' do
      expect {
        described_class.new(user: user, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 10).call
      }.not_to raise_error
    end

    it 'does not raise error for bitcoin to usd' do
      expect {
        described_class.new(user: user, from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1).call
      }.not_to raise_error
    end
  end

  context 'when the currency pair is invalid' do
    it 'raises error' do
      expect {
        described_class.new(user: user, from_currency: 'usd', to_currency: 'eth', amount_from: 10).call
      }.to raise_error(StandardError, 'Invalid currency pair. Only USD to BTC and BTC to USD are supported.')
    end
  end

  context 'when the balance is insufficient' do
    let(:user) { create(:user, :with_no_balance) }

    it 'raises error for usd to bitcoin' do
      expect {
        described_class.new(user: user, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 10).call
      }.to raise_error(StandardError, 'Insufficient balance')
    end

    it 'raises error for bitcoin to usd' do
      expect {
        described_class.new(user: user, from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1).call
      }.to raise_error(StandardError, 'Insufficient balance')
    end
  end

  context 'when the balance is sufficient' do
    it 'does not raise error for usd to bitcoin' do
      expect {
        described_class.new(user: user, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 100).call
      }.not_to raise_error
    end

    it 'does not raise error for bitcoin to usd' do
      expect {
        described_class.new(user: user, from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1).call
      }.not_to raise_error
    end
  end
end 