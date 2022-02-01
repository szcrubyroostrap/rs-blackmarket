class CartProductSerializer < Blueprinter::Base
  identifier :id

  fields :quantity, :total_amount

  association :cart, blueprint: CartSerializer
  association :product, blueprint: ProductSerializer

  view :cart_resume do
    field :quantity
    excludes :cart, :product
  end
end
