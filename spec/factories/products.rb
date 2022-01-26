FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph_by_chars }
    price { Faker::Number.between(from: 1, to: 1000) }
    rating { Faker::Number.between(from: 0, to: 5) }
    status { 1 }
    stock { 10 }
  end
end
