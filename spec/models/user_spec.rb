require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:balance_usd) }
  it { should validate_presence_of(:balance_btc) }

  it { should have_many(:transactions) }

  it { should validate_numericality_of(:balance_usd).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:balance_btc).is_greater_than_or_equal_to(0) }
end
