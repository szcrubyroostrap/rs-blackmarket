module Api
  module V1
    class CitiesController < Api::V1::ApiController
      def index
        render json: CitySerializer.render(country.cities, root: :cities), status: :ok
      end

      def create
        new_city = country.cities.create!(cities_params)

        render json: CitySerializer.render(new_city, view: :with_country), status: :created
      end

      def show
        render json: CitySerializer.render(city), status: :ok
      end

      def update
        city.update!(cities_params)

        render json: CitySerializer.render(city), status: :ok
      end

      def destroy
        city.destroy!

        head :no_content
      end

      private

      def cities_params
        params.require(:city).permit(:name)
      end

      def city
        @city ||= country.cities.find(params[:id])
      end

      def country
        @country ||= Country.find(params[:country_id])
      end
    end
  end
end
