class ProductSerializer < Blueprinter::Base
  identifier :id

  fields :name, :description, :price, :rating, :status, :stock

  view :with_cart_resume do
    excludes :rating, :status, :stock
    include_view :total_added_to_cart
  end

  view :total_added_to_cart do
    association :cart_products, view: :cart_resume, blueprint: CartProductSerializer
  end
end
