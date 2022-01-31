describe 'PUT /api/v1/cart/products', type: :request do
  subject { put api_v1_cart_product_path(product.id), headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      product: {
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

    before { subject }

    context 'when adding Products to cart' do
      let(:quantity) { 1 }

      it_behaves_like 'a successful request'

      it 'returns the schema information specified in the serializer' do
        expect(json).to include_json(
          id: product.id,
          cart_products: [
            {
              id: cart_product.id,
              quantity: 3,
              total_amount: product.price * 3
            }
          ],
          description: product.description,
          name: product.name,
          price: product.price
        )
      end
    end

    context 'when removing Products to cart' do
      let(:quantity) { -1 }

      it_behaves_like 'a successful request'

      it 'returns the schema information specified in the serializer' do
        expect(json).to include_json(
          id: product.id,
          cart_products: [
            {
              id: cart_product.id,
              quantity: 1,
              total_amount: product.price * 1
            }
          ],
          description: product.description,
          name: product.name,
          price: product.price
        )
      end
    end
  end

  context 'when response is an error' do
    let(:quantity) { 1 }

    before { subject }

    context 'when product does not exist' do
      let(:product) { build(:product, id: 1) }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:product) { create(:product) }
      let(:params) { { quantity: quantity } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:product) { create(:product) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when quantity provided is zero' do
      let(:product) { create(:product) }
      let(:quantity) { 0 }

      it_behaves_like 'a bad request'

      it 'returns a message error' do
        msg = 'it is not possible to operate with the quantity supplied'

        expect(json).to match(error: msg)
      end
    end
  end
end
