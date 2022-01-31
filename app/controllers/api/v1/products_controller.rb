module Api
  module V1
    class ProductsController < Api::V1::ApiController
      def create
        cart_item_management.create_product_in_cart

        render json: response_data, status: :created
      end

      def destroy
        cart_item_management.remove_product_from_cart

        render json: response_data, status: :ok
      end

      def update
        cart_item_management.update_product_units_in_cart(product_params[:quantity])

        render json: response_data, status: :ok
      end

      private

      def product_params
        params.require(:product).permit(:id, :quantity)
      end

      def cart
        @cart ||= current_user.carts.find_or_create_by!(status: :in_process)
      end

      def product
        @product ||= Product.find(params[:id] || product_params[:id])
      end

      def cart_item_management
        CartItemsManagementService.new(cart, product)
      end

      def response_data
        ProductSerializer.render(product, view: :with_cart_resume)
      end
    end
  end
end
