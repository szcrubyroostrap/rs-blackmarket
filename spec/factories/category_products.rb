FactoryBot.define do
  factory :category_product do
    product_id { create(:product).id }
    category_id { create(:category).id }
  end
end
