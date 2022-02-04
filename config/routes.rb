Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resource :cart, only: :show do
        resources :products, only: %i[create destroy update]
      end

      resources :users, only: [] do
        resources :addresses, except: %i[edit new]
      end

      resources :countries, except: %i[edit new] do
        resources :cities, except: %i[edit new]
      end
    end
  end
end
