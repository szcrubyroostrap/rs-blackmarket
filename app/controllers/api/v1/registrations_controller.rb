module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      # skip_before_action :verify_authenticity_token

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
