module Api
  module V1
    class CountriesController < Api::V1::ApiController
      def index
        render json: CountrySerializer.render(Country.all), status: :ok
      end

      def create
        new_country = Country.create!(countries_params)

        render json: CountrySerializer.render(new_country), status: :created
      end

      def show
        render json: CountrySerializer.render(country), status: :ok
      end

      def update
        country.update!(countries_params)

        render json: CountrySerializer.render(country), status: :ok
      end

      def destroy
        country.destroy!

        head :no_content
      end

      private

      def countries_params
        params.require(:country).permit(:name)
      end

      def country
        @country ||= Country.find(params[:id])
      end
    end
  end
end
