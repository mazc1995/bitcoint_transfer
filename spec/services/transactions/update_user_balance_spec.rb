require 'rails_helper'

RSpec.describe Transactions::UpdateUserBalance do
  let(:user) { create(:user, balance_usd: 1000, balance_btc: 2) }

  it 'actualiza correctamente usd a bitcoin' do
    expect {
      described_class.new(user: user, from_currency: 'usd', to_currency: 'bitcoin', amount_from: 100, amount_to: 0.002).call
    }.to change { user.reload.balance_usd }.by(-100)
     .and change { user.reload.balance_btc }.by(0.002)
  end

  it 'actualiza correctamente bitcoin a usd' do
    expect {
      described_class.new(user: user, from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1, amount_to: 5000).call
    }.to change { user.reload.balance_btc }.by(-0.1)
     .and change { user.reload.balance_usd }.by(5000)
  end

  it 'lanza error si el par es inválido' do
    expect {
      described_class.new(user: user, from_currency: 'usd', to_currency: 'eth', amount_from: 100, amount_to: 1).call
    }.to raise_error(StandardError, 'Invalid currency pair for balance update')
  end
end 