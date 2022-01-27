Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/v1/users', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      put :add_product, to: 'carts#add_product', path: 'carts/add_product'
      put :remove_product, to: 'carts#remove_product', path: 'carts/remove_product'
      get :collection, to: 'carts#collection', path: 'carts/collection'
    end
  end
end
