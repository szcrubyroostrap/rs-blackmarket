module Api
  module V1
    class CartsController < Api::V1::ApiController
      before_action :load_cart, :find_product, :cart_item_management,
                    only: %i[add_product remove_product]

      def add_product
        @item.add_to_cart

        render json: { message: response_message }, status: :ok
      end

      def remove_product
        @item.remove_from_cart

        render json: { message: response_message }, status: :ok
      end

      private

      def update_cart_params
        params.require(:cart).permit(:product_id, :quantity)
      end

      def load_cart
        @cart = current_user.carts.find_or_create_by!(status: :in_process)
      end

      def find_product
        @product = Product.find(update_cart_params[:product_id])
      end

      def cart_item_management
        @item = CartItemsManagementService.new(@cart, @product, update_cart_params[:quantity])
      end

      def response_message
        action = case action_name
                 when 'add_product'
                   'added'
                 when 'remove_product'
                   'removed'
                 end

        "#{update_cart_params[:quantity]} #{'unit'.pluralize(update_cart_params[:quantity])} "\
          "of the Product #{@product.id} have been successfully #{action}"
      end
    end
  end
end
