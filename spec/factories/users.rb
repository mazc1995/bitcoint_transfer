FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    balance_usd { 500 }
    balance_btc { 500 }
  end

  trait :with_no_balance do
    balance_usd { 0 }
    balance_btc { 0 }
  end
end
