module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      protect_from_forgery with: :null_session
      include Api::Concerns::RequestsResponses

      private

      def resource_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
