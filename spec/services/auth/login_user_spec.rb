require 'rails_helper'

RSpec.describe Auth::LoginUser do
  let!(:user) do
    User.create!(
      name: 'Test User',
      email: 'loginuser@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      balance_usd: 1000,
      balance_btc: 0.5
    )
  end

  it 'logea exitosamente y retorna token' do
    result = described_class.new('loginuser@example.com', 'password123').call
    expect(result).to be_success
    expect(result.user).to eq(user)
    expect(result.token).to be_present
    expect(result.error).to be_nil
  end

  it 'falla con password incorrecto' do
    result = described_class.new('loginuser@example.com', 'wrongpass').call
    expect(result).not_to be_success
    expect(result.user).to be_nil
    expect(result.token).to be_nil
    expect(result.error).to eq('Invalid email or password')
  end

  it 'falla con email inexistente' do
    result = described_class.new('noexiste@example.com', 'password123').call
    expect(result).not_to be_success
    expect(result.user).to be_nil
    expect(result.token).to be_nil
    expect(result.error).to eq('Invalid email or password')
  end
end 