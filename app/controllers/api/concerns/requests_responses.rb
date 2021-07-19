module Api
  module Concerns
    module RequestsResponses
      extend ActiveSupport::Concern

      def render_error(status, message, _data = nil)
        response = {
          error: message
        }
        render json: response, status: status
      end
    end
  end
end
