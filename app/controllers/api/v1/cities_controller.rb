module Api
  module V1
    class CitiesController < Api::V1::ApiController
      def index
        render json: response_data(country.cities), status: :ok
      end

      def create
        new_city = country.cities.create!(city_params)

        render json: response_data(new_city), status: :created
      end

      def show
        render json: response_data(city), status: :ok
      end

      def update
        city.update!(city_params)

        render json: response_data(city), status: :ok
      end

      def destroy
        city.destroy!

        head :no_content
      end

      private

      def city_params
        params.require(:city).permit(:name)
      end

      def city
        @city ||= country.cities.find(params[:id])
      end

      def country
        @country ||= Country.find(params[:country_id])
      end

      def response_data(data)
        CitySerializer.render(data, view: :with_associations)
      end
    end
  end
end
