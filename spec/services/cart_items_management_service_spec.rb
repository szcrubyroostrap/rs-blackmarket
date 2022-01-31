describe CartItemsManagementService, type: :service do
  describe '#create_product_in_cart' do
    subject { CartItemsManagementService.new(cart, product).create_product_in_cart }

    let(:cart) { create(:cart, :with_user) }
    let(:product) { create(:product) }

    context 'when Product has already been added to the cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product)
      end

      before { cart_product }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::CreatingProductInCartError)
      end
    end

    context 'when Product is not in cart' do
      it 'creates a CartProduct' do
        expect { subject }.to change { CartProduct.count }.by(1)
      end

      it 'establishes a relationship beetween Cart and CartProduct' do
        subject

        expect(cart.cart_products.size).to eq(1)
      end

      it 'adds item to cart' do
        subject

        expect(cart.total_items).to eq(1)
      end

      it 'updates the total_price' do
        subject
        price = product.price * 1

        expect(cart.total_price).to eq(price)
      end
    end
  end

  describe '#remove_product_from_cart' do
    subject { CartItemsManagementService.new(cart, product).remove_product_from_cart }

    let(:cart) { create(:cart, :with_user, total_items: 11, total_price: 22) }
    let(:product) { create(:product) }

    context 'when Product is not in cart' do
      it 'raises an error' do
        expect { subject }.to raise_error(Services::ProductToRemoveNotAddedError)
      end
    end

    context 'when Product is in cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: 2, total_amount: 20)
      end

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
  end

  describe '#update_product_units_in_cart' do
    subject { CartItemsManagementService.new(cart, product).update_product_units_in_cart(units) }

    let(:cart) { create(:cart, :with_user, total_items: 11, total_price: 22) }
    let(:product) { create(:product, price: 10) }

    context 'when unit supplied is not valid' do
      let(:units) { 1.5 }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::UnitsToOperateError)
      end
    end

    context 'when Product is not in cart' do
      let(:units) { 1 }

      it 'raises an error' do
        expect { subject }.to raise_error(Services::MissingProductUpdateError)
      end
    end

    context 'when Product is added in cart' do
      let(:cart_product) do
        create(:cart_product, cart: cart, product: product, quantity: quantity,
                              total_amount: total_amount)
      end
      let(:total_amount) { product.price * quantity }
      let(:quantity) { 2 }

      before { cart_product }

      context 'when Product does not have enough stock to add' do
        let(:units) { 100 }

        it 'raises an error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when adding Products to cart' do
        let(:units) { 1 }

        it 'does not create a CartProduct' do
          expect { subject }.to change { CartProduct.count }.by(0)
        end

        it 'remains the relationship beetween Cart and CartProduct' do
          subject

          expect(cart.cart_products.size).to eq(1)
        end

        it 'adds item to cart' do
          subject

          expect(cart.total_items).to eq(3)
        end

        it 'updates the total_price' do
          subject
          total_price = product.price * 3

          expect(cart.total_price).to eq(total_price)
        end
      end

      context 'when removing Products from cart' do
        context 'when the Product quantity to remove is bigger than were added to cart' do
          let(:units) { -5 }

          it 'raises an error' do
            expect { subject }.to raise_error(Services::RemoveMoreProductsThanWereAddedError)
          end
        end

        context 'when units of the Product to be eliminated reach zero in the cart' do
          let(:units) { -2 }

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
          let(:units) { -1 }

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
  end
end
