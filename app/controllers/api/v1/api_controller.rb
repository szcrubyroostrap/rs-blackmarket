module Api
  module V1
    class ApiController < ActionController::API
      include ActionController::RequestForgeryProtection
      include DeviseTokenAuth::Concerns::SetUserByToken
      include Api::Concerns::ErrorsHandling

      protect_from_forgery unless: -> { request.format.json? }

      before_action :authenticate_user!
    end
  end
end
