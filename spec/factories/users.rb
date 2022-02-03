FactoryBot.define do
  factory :user do
    email      { Faker::Internet.unique.email }
    password   { Faker::Internet.password(min_length: 8) }
  end
end
