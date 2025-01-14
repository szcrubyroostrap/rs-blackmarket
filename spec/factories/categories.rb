FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    parent_category_id { nil }
  end

  trait :with_parent_category do
    parent_category { create(:category) }
  end
end
