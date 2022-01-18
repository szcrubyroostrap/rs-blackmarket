module Api
  module V1
    class CartsController < Api::V1::ApiController
      def add_product
        load_cart
        find_product
        add_to_cart

        render json: {
          message: "#{add_to_cart_params[:quantity]} units of the Product #{@product.id} "\
                   'have been successfully added'
        },
               status: :ok
      end

      private

      def add_to_cart_params
        params.require(:cart).permit(:product_id, :quantity)
      end

      def load_cart
        @cart = current_user.carts.find_or_create_by!(status: :in_process)
      end

      def find_product
        @product = Product.find(add_to_cart_params[:product_id])
      end

      def add_to_cart
        cart_product = CartProduct.find_or_initialize_by(cart: @cart, product: @product)
        cart_product.quantity += add_to_cart_params[:quantity]
        cart_product.total_amount = @product.price * cart_product.quantity
        cart_product.save!

        @cart.update!(total_items: @cart.calculate_total_items,
                      total_price: @cart.calculate_total_price)
      end
    end
  end
end
