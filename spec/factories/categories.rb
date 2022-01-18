FactoryBot.define do
  factory :category do
    name { Faker::Commerce.department }
    association :parent_category, strategy: :null
  end

  trait :with_parent_category do
    parent_category_id { create(:category).id }
  end
end
