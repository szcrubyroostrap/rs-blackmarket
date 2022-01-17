FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph_by_chars }
    price { Faker::Number.between(from: 1, to: 1000) }
    rating { Faker::Number.digit }
    status { 1 }
    stock { Faker::Number.between(from: 1, to: 100) }
  end
end
