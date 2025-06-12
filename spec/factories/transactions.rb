FactoryBot.define do
  factory :transaction do
    user
    from_currency { Faker::Currency.code }
    to_currency { Faker::Currency.code }
    amount_from { Faker::Number.decimal(l_digits: 16, r_digits: 2) }
    amount_to { Faker::Number.decimal(l_digits: 16, r_digits: 2) }
    price_reference { Faker::Number.decimal(l_digits: 16, r_digits: 2) }
    status { :pending }
  end

  trait :completed do
    status { :completed }
  end

  trait :failed do
    status { :failed }
  end
end
