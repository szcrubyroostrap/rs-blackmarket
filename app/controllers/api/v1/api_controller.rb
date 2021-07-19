module Api
  module V1
    class ApiController < ActionController::API
      # Prevent CSRF attacks by raising an exception.
      protect_from_forgery with: :exception
    end
  end
end
