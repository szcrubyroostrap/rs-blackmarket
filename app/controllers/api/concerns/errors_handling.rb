module Api
  module Concerns
    module ErrorsHandling
      extend ActiveSupport::Concern

      included do
        rescue_from StandardError, with: :standard_error
        rescue_from ActionController::ParameterMissing, with: :parameter_missing
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
        rescue_from Services::UnitsToOperateError, with: :standard_error
        rescue_from Services::ProductToRemoveNotAddedError, with: :standard_error
        rescue_from Services::RemoveMoreProductsThanWereAddedError, with: :standard_error
      end

      private

      def standard_error(exception)
        render json: { error: exception.message }, status: :bad_request
      end

      def parameter_missing(exception)
        render json: { error: exception.exception.message }, status: :bad_request
      end

      def record_not_found(exception)
        render json: { error: exception.exception.message }, status: :not_found
      end

      def record_invalid(exception)
        render json: { error: exception.record.errors.as_json }, status: :bad_request
      end
    end
  end
end
