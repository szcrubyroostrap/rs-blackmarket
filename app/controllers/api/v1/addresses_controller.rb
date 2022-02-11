module Api
  module V1
    class AddressesController < Api::V1::ApiController
      def index
        cities = current_user.addresses.includes(:city)

        render json: response_data(cities), status: :ok
      end

      def create
        new_address = current_user.addresses.create!(address_params)

        render json: response_data(new_address), status: :created
      end

      def show
        render json: response_data(address), status: :ok
      end

      def update
        address.update!(address_params)

        render json: response_data(address), status: :ok
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

      def response_data(data)
        AddressSerializer.render(data, view: :with_associations)
      end
    end
  end
end
