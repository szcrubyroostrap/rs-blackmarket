describe CartItemsManagementService, type: :service do
  describe '#add_to_cart' do
    subject { CartItemsManagementService.new(cart, product, quantity).add_to_cart }

    let(:cart) { create(:cart, :with_user) }
    let(:product) { create(:product) }
    let(:quantity) { 1 }

    context 'when product does not have enough stock' do
      let(:quantity) { 100 }

      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when quantity supplied is not valid' do
      let(:quantity) { -5 }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::UnitsToOperateError)
      end
    end

    context 'when product is not in cart' do
      it 'creates a CartProduct' do
        expect { subject }.to change { CartProduct.count }.by(1)
      end

      it 'establishes a relationship beetween Cart and CartProduct' do
        subject

        expect(cart.cart_products.size).to eq(1)
      end

      it 'adds item to cart' do
        subject

        expect(cart.total_items).to eq(quantity)
      end

      it 'updates the total_price' do
        subject
        price = product.price * quantity

        expect(cart.total_price).to eq(price)
      end
    end

    context 'when product has been added to cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: quantity,
                              total_amount: total_amount)
      end
      let(:total_amount) { product.price * quantity }

      before { cart_product }

      it 'does not create a CartProduct' do
        expect { subject }.to change { CartProduct.count }.by(0)
      end

      it 'remains the relationship beetween Cart and CartProduct' do
        subject

        expect(cart.cart_products.size).to eq(1)
      end

      it 'adds item to cart' do
        subject

        expect(cart.total_items).to eq(2)
      end

      it 'updates the total_price' do
        subject
        total_price = product.price * 2

        expect(cart.total_price).to eq(total_price)
      end
    end
  end

  describe '#remove_from_cart' do
    subject { CartItemsManagementService.new(cart, product, quantity).remove_from_cart }

    let(:cart) { create(:cart, :with_user, total_items: 2, total_price: 20) }
    let(:product) { create(:product, price: 10) }

    context 'when quantity supplied is not valid' do
      let(:quantity) { -5 }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::UnitsToOperateError)
      end
    end

    context 'when product is not added to cart' do
      let(:quantity) { 1 }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::ProductToRemoveNotAddedError)
      end
    end

    context 'when the product quantity to remove is bigger than were added to cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: 1)
      end
      let(:quantity) { 5 }

      before { cart_product }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::RemoveMoreProductsThanWereAddedError)
      end
    end

    context 'when there are no units to remove from the product in the cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: quantity, total_amount: 10)
      end
      let(:quantity) { 1 }

      before { cart_product }

      it 'destroys the CartProduct' do
        expect { subject }.to change { CartProduct.count }.by(-1)
      end

      it 'removes relationship beetween Cart and CartProduct' do
        subject
        cart.reload

        expect(cart.cart_products.size).to eq(0)
      end

      it 'updates the cart items' do
        subject

        expect(cart.total_items).to eq(0)
      end

      it 'updates the cart total_price' do
        subject

        expect(cart.total_price).to eq(0)
      end
    end

    context 'when removes items from the cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: 20)
      end
      let(:quantity) { 1 }

      before { cart_product }

      it 'does not destroy the CartProduct' do
        expect { subject }.to change { CartProduct.count }.by(0)
      end

      it 'does not remove relationship beetween Cart and CartProduct' do
        subject
        cart.reload

        expect(cart.cart_products.size).to eq(1)
      end

      it 'updates the cart items' do
        subject

        expect(cart.total_items).to eq(1)
      end

      it 'updates the cart total_price' do
        subject
        total_price = product.price * 1

        expect(cart.total_price).to eq(total_price)
      end
    end
  end
end
