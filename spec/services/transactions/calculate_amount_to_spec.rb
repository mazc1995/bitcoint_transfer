require 'rails_helper'

RSpec.describe Transactions::CalculateAmountTo do
  let(:price) { 50_000.0 }

  it 'calcula correctamente usd a bitcoin' do
    result = described_class.new(from_currency: 'usd', to_currency: 'bitcoin', amount_from: 100, price: price).call
    expect(result).to eq(0.002)
  end

  it 'calcula correctamente bitcoin a usd' do
    result = described_class.new(from_currency: 'bitcoin', to_currency: 'usd', amount_from: 0.1, price: price).call
    expect(result).to eq(5000.0)
  end

  it 'lanza error si el par es inválido' do
    expect {
      described_class.new(from_currency: 'usd', to_currency: 'eth', amount_from: 100, price: price).call
    }.to raise_error(StandardError, 'Invalid currency pair for calculation')
  end
end 