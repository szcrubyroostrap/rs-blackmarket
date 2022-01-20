FactoryBot.define do
  factory :cart_product do
    cart
    product
    quantity { 0 }
    total_amount { 0 }
  end

  trait :with_cart_and_product do
    cart { create(:cart, :with_user) }
    product { create(:product) }
  end
end
