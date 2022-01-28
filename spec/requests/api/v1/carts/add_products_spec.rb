describe 'PUT /api/v1/carts/add_product', type: :request do
  subject { put add_product_api_v1_carts_path, headers: headers, params: params, as: :json }

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

  before { subject }

  context 'when response is successful' do
    let(:product) { create(:product) }
    let(:quantity) { 1 }

    it_behaves_like 'a successful request'

    it 'returns correct json message' do
      msg = "#{quantity} unit of the Product #{product.id} have been successfully added"

      expect(json).to match(message: msg)
    end
  end

  context 'when response is an error' do
    context 'when product does not exist' do
      let(:product) { build(:product) }
      let(:quantity) { 1 }

      it_behaves_like 'a not found request'
    end

    context 'when quantity param format is not valid' do
      let(:product) { create(:product) }
      let(:quantity) { 'not valid' }

      it_behaves_like 'a bad request'
    end

    context 'when request format is not valid' do
      let(:product) { create(:product) }
      let(:quantity) { 1 }
      let(:params) { { product_id: product.id, quantity: quantity } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:quantity) { 1 }
      let(:product) { create(:product) }

      it_behaves_like 'an unauthorised request'
    end
  end
end
