describe 'POST /api/v1/cart/products', type: :request do
  subject { post api_v1_cart_products_path, headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      product: {
        id: product.id
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    let(:product) { create(:product) }

    it_behaves_like 'a successful request'

    it 'returns product info' do
      cart_product = CartProduct.find_by(cart: user.carts.first, product: product)

      expect(json).to include_json(
        id: product.id,
        cart_products: [
          {
            id: cart_product.id,
            quantity: cart_product.quantity,
            total_amount: cart_product.total_amount
          }
        ],
        description: product.description,
        name: product.name,
        price: product.price
      )
    end
  end

  context 'when response is an error' do
    context 'when product does not exist' do
      let(:product) { build(:product, id: 1) }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:product) { create(:product) }
      let(:params) { { product_id: product.id } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:product) { create(:product) }

      it_behaves_like 'an unauthorised request'
    end
  end
end
