FactoryBot.define do
  factory :cart do
    quantity { 1 }
    total_price { 1.5 }
    user { nil }
  end
end
