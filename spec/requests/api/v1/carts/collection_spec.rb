describe 'GET /api/v1/carts/add_product', type: :request do
  subject { get collection_api_v1_carts_path, headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  context 'when response is an error' do
    before { subject }

    context 'when cart does not exist' do
      it_behaves_like 'a not found request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end

  context 'when response is successful' do
    let(:cart) { create(:cart, user: user, total_items: quantity, total_price: 20) }
    let(:product) { create(:product, price: 10) }
    let!(:cart_product) do
      create(:cart_product, cart: cart, product: product, quantity: quantity,
                            total_amount: total_amount)
    end
    let(:quantity) { 2 }
    let(:total_amount) { product.price * quantity }

    before { subject }

    it_behaves_like 'a successful request'

    it 'returns the schema information specified in the serializer' do
      expect(json).to include_json(
        id: cart.id,
        products: [
          {
            id: product.id,
            cart_products: [
              {
                id: cart_product.id,
                quantity: quantity,
                total_amount: total_amount
              }
            ],
            description: product.description,
            name: product.name,
            price: product.price
          }
        ],
        status: 'in_process',
        total_items: quantity,
        total_price: total_amount,
        user: {
          id: user.id,
          email: user.email
        }
      )
    end
  end
end
