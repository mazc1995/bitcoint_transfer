FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    balance_usd { Faker::Number.decimal(l_digits: 16, r_digits: 2) }
    balance_btc { Faker::Number.decimal(l_digits: 16, r_digits: 8) }
  end
end
