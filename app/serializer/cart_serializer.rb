class CartSerializer < Blueprinter::Base
  identifier :id

  fields :total_items, :total_price, :status

  association :user, blueprint: UserSerializer
  association :products, blueprint: ProductSerializer

  view :with_product_resume do
    association :products, view: :with_cart_resume, blueprint: ProductSerializer
  end
end
