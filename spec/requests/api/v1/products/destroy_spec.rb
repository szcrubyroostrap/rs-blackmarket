describe 'DELETE /api/v1/cart/products/:id', type: :request do
  subject { delete api_v1_cart_product_path(product.id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  context 'when response is successful' do
    let(:cart) { create(:cart, user: user, total_items: 2, total_price: 20) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_product) do
      create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: total_amount)
    end
    let(:total_amount) { product.price * 2 }

    before { subject }

    it_behaves_like 'a successful request'

    it 'returns the schema information specified in the serializer' do
      expect(json).to include_json(
        id: product.id,
        cart_products: [],
        description: product.description,
        name: product.name,
        price: product.price
      )
    end
  end

  context 'when response is an error' do
    before { subject }

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:product) { create(:product) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when product does not exist' do
      let(:product) { build(:product, id: 1) }

      it_behaves_like 'a not found request'
    end
  end
end
