describe 'GET /api/v1/carts/add_product', type: :request do
  subject { get api_v1_collection_path, headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  context 'when response is an error' do
    before { subject }

    context 'when cart does not exist' do
      it_behaves_like 'response not found'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'user is not logged in'
    end
  end

  context 'when response is successful' do
    let(:cart) { create(:cart, user: user, total_items: 2, total_price: 20) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_product) do
      create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: total_amount)
    end
    let(:total_amount) { product.price * 2 }

    before { subject }

    it_behaves_like 'response successful'

    it 'returns the correct response keys' do
      expect(json.keys).to contain_exactly('id', 'products', 'status', 'total_items',
                                           'total_price', 'user')
    end

    it 'returns the schema information specified in the serializer' do
      data_serialized = CartSerializer.render_as_json(cart, view: :with_product_resume)

      expect(json).to eq(data_serialized)
    end
  end
end
