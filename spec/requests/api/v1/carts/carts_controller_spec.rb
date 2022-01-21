describe '/api/v1/carts/', type: :request do
  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  shared_examples 'response bad_request' do
    it 'returns http bad request code' do
      expect(response).to be_bad_request
    end
  end

  describe 'add_product' do
    subject { post '/api/v1/carts/add_product', headers: headers, params: params, as: :json }

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

      it 'returns http success code' do
        expect(response).to be_successful
      end

      it 'returns correct json message' do
        msg = "#{quantity} unit of the Product #{product.id} have been successfully added"

        expect(json).to match(message: msg)
      end
    end

    context 'when response is an error' do
      context 'when product does not exist' do
        let(:product) { build(:product) }
        let(:quantity) { 1 }

        it 'returns http not found code' do
          expect(response).to be_not_found
        end
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
    end
  end

  describe 'remove_product' do
    subject { post '/api/v1/carts/remove_product', headers: headers, params: params, as: :json }

    let(:params) do
      {
        cart: {
          product_id: product.id,
          quantity: quantity
        }
      }
    end

    context 'when response is successful' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: total_amount)
      end
      let(:cart) { create(:cart, user: user, total_items: 2, total_price: 20) }
      let(:product) { create(:product, price: 10) }
      let(:total_amount) { product.price * 2 }
      let(:quantity) { 1 }

      before do
        cart_product
        subject
      end

      it 'returns http success code' do
        expect(response).to be_successful
      end

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

        it 'returns http not found code' do
          expect(response).to be_not_found
        end
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
    end
  end
end
