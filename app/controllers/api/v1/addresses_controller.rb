module Api
  module V1
    class AddressesController < Api::V1::ApiController
      def index
        cities = current_user.addresses.includes(:city)

        render json: AddressSerializer.render(cities, view: :with_associations), status: :ok
      end

      def create
        new_address = current_user.addresses.create!(address_params)

        render json: AddressSerializer.render(new_address, view: :with_associations),
               status: :created
      end

      def show
        render json: AddressSerializer.render(address, view: :with_associations), status: :ok
      end

      def update
        address.update!(address_params)

        render json: AddressSerializer.render(address, view: :with_associations), status: :ok
      end

      def destroy
        address.destroy!

        head :no_content
      end

      private

      def address_params
        params.require(:address).permit(:home_address, :zip_code, :city_id)
      end

      def address
        @address ||= current_user.addresses.find(params[:id])
      end
    end
  end
end
