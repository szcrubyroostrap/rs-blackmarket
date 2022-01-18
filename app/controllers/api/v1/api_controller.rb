module Api
  module V1
    class ApiController < ActionController::API
      include ActionController::RequestForgeryProtection
      include DeviseTokenAuth::Concerns::SetUserByToken

      protect_from_forgery unless: -> { request.format.json? }

      before_action :authenticate_user!

      rescue_from StandardError do |exception|
        render json: { error: exception.message }, status: :bad_request
      end

      rescue_from ActionController::ParameterMissing do |exception|
        render json: { error: exception.exception.message }, status: :bad_request
      end

      rescue_from ActiveRecord::RecordNotFound do |exception|
        render json: { error: exception.exception.message }, status: :not_found
      end

      rescue_from ActiveRecord::RecordInvalid do |exception|
        render json: { error: exception.record.errors.as_json }, status: :bad_request
      end
    end
  end
end
