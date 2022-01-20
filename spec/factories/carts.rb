FactoryBot.define do
  factory :cart do
    total_items { 0 }
    total_price { 0.0 }
    status { 0 }
    user { nil }
  end

  trait :with_user do
    user
  end
end
