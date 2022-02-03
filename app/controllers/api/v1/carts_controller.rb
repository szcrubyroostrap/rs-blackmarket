module Api
  module V1
    class CartsController < Api::V1::ApiController
      def show
        cart = current_user.carts.find_by!(status: :in_process)

        render json: CartSerializer.render(cart, view: :with_product_resume), status: :ok
      end
    end
  end
end
