require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of(:from_currency) }
  it { should validate_presence_of(:to_currency) }
  it { should validate_presence_of(:amount_from) }
  it { should validate_presence_of(:amount_to) }
  it { should validate_presence_of(:price_reference) }
  it { should validate_presence_of(:status) }

  it { should validate_numericality_of(:amount_from).is_greater_than(0) }
  it { should validate_numericality_of(:amount_to).is_greater_than(0) }
  it { should validate_numericality_of(:price_reference).is_greater_than(0) }

  it { should define_enum_for(:status).with_values(%i[pending completed failed]) }

  it { should belong_to(:user) }
end
