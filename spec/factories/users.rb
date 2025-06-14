FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    balance_usd { 500 }
    balance_btc { 500 }
  end

  trait :with_no_balance do
    balance_usd { 0 }
    balance_btc { 0 }
  end
end
