require 'rails_helper'

RSpec.describe Auth::RegisterUser do
  let(:valid_params) do
    {
      name: 'Test User',
      email: 'testuser@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      balance_usd: 1000,
      balance_btc: 0.5
    }
  end

  it 'registra un usuario exitosamente y retorna token' do
    result = described_class.new(valid_params).call
    expect(result).to be_success
    expect(result.user).to be_persisted
    expect(result.token).to be_present
    expect(result.errors).to be_nil
  end

  it 'falla si el email ya existe' do
    User.create!(valid_params)
    result = described_class.new(valid_params).call
    expect(result).not_to be_success
    expect(result.user).to be_nil
    expect(result.token).to be_nil
    expect(result.errors).to include('Email has already been taken')
  end

  it 'falla si las contraseñas no coinciden' do
    params = valid_params.merge(password_confirmation: 'otra')
    result = described_class.new(params).call
    expect(result).not_to be_success
    expect(result.errors).to include("Password confirmation doesn't match Password")
  end
end 