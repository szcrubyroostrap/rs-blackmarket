describe 'PUT /api/v1/carts/remove_product', type: :request do
  subject { put api_v1_remove_product_path, headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      cart: {
        product_id: product.id,
        quantity: quantity
      }
    }
  end

  context 'when response is successful' do
    let(:cart) { create(:cart, user: user, total_items: 2, total_price: 20) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_product) do
      create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: total_amount)
    end
    let(:total_amount) { product.price * 2 }
    let(:quantity) { 1 }

    before { subject }

    it_behaves_like 'response successful'

    it 'returns correct json message' do
      msg = "1 unit of the Product #{product.id} have been successfully removed"

      expect(json).to match(message: msg)
    end
  end

  context 'when response is an error' do
    before { subject }

    context 'when product does not exist' do
      let(:product) { build(:product) }
      let(:quantity) { 1 }

      it_behaves_like 'response not found'
    end

    context 'when quantity param format is not valid' do
      let(:product) { create(:product) }
      let(:quantity) { 'not valid' }

      it_behaves_like 'response bad_request'
    end

    context 'when request format is not valid' do
      let(:product) { create(:product) }
      let(:quantity) { 1 }
      let(:params) { { product_id: product.id, quantity: quantity } }

      it_behaves_like 'response bad_request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:quantity) { 1 }
      let(:product) { create(:product) }

      it_behaves_like 'user is not logged in'
    end
  end
end
