Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resource :carts, only: [] do
        collection do
          put :add_product
          put :remove_product
          get :collection
        end
      end
    end
  end
end
