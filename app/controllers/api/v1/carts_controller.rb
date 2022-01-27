module Api
  module V1
    class CartsController < Api::V1::ApiController
      def add_product
        cart_item_management.add_to_cart

        render json: { message: response_message('added') }, status: :ok
      end

      def remove_product
        cart_item_management.remove_from_cart

        render json: { message: response_message('removed') }, status: :ok
      end

      private

      def update_cart_params
        params.require(:cart).permit(:product_id, :quantity)
      end

      def cart
        @cart ||= current_user.carts.find_or_create_by!(status: :in_process)
      end

      def product
        @product ||= Product.find(update_cart_params[:product_id])
      end

      def cart_item_management
        CartItemsManagementService.new(cart, product, update_cart_params[:quantity])
      end

      def response_message(action)
        quantity = update_cart_params[:quantity]

        "#{quantity} #{'unit'.pluralize(quantity)} of the Product #{@product.id} "\
          "have been successfully #{action}"
      end
    end
  end
end
