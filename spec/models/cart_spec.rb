RSpec.describe Cart, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:total_items).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:total_price).of_type(:float).with_options(null: false)
      expect(subject).to have_db_column(:status).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:user_id).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(null: false)
      expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)
    end

    it 'has indexes' do
      expect(subject).to have_db_index(:user_id)
    end
  end

  describe 'associations' do
    it 'has relationships' do
      expect(subject).to have_many(:cart_products).dependent(:destroy)
      expect(subject).to have_many(:products).through(:cart_products)
      expect(subject).to belong_to(:user)
    end
  end

  describe 'validations' do
    it 'validates the total_items attribute' do
      is_expected.to validate_presence_of(:total_items)
    end

    it 'validates the total_price attribute' do
      is_expected.to validate_presence_of(:total_price)
    end

    it 'validates the total_items attribute is greater or equal than 0' do
      is_expected.to validate_numericality_of(:total_items).is_greater_than_or_equal_to(0)
    end

    it 'validates the total_price attribute is greater or equal than 0' do
      is_expected.to validate_numericality_of(:total_price).is_greater_than_or_equal_to(0)
    end

    it 'validates the rating status is an enumerator' do
      is_expected.to define_enum_for(:status).with_values(in_process: 0, completed: 1)
    end
  end

  describe '#create' do
    let(:user) { create(:user) }

    context 'when transaction is successful' do
      let(:cart) { build(:cart, user: user) }

      it 'is valid' do
        expect(cart.valid?).to be_truthy
      end

      it 'does not have errors' do
        cart.valid?
        expect(user.errors).to be_empty
      end

      it 'is saved in database' do
        expect { cart.save! }.to change { Cart.count }.by(1)
      end
    end

    context 'when transaction failed' do
      let(:cart) { build(:cart, user: user, total_items: total_items, total_price: total_price) }

      context 'when total_items has negative values' do
        let(:total_items) { -1 }
        let(:total_price) { 0.0 }

        it 'raises error' do
          expect { cart.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'is not saved in database' do
          expect { cart.save }.to change { Cart.count }.by(0)
        end
      end

      context 'when total_price has negative values' do
        let(:total_items) { 0 }
        let(:total_price) { -1 }

        it 'raises error' do
          expect { cart.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'is not saved in database' do
          expect { cart.save }.to change { Cart.count }.by(0)
        end
      end
    end
  end

  describe '#update' do
    let(:cart) { create(:cart, user: user) }
    let(:user) { create(:user) }

    context 'when transaction is successful' do
      let(:total_items) { 1 }
      let(:total_price) { 1.0 }

      before do
        cart.update!(total_items: total_items, total_price: total_price)
      end

      it 'updates total_items attribute' do
        expect(cart.reload.total_items).to eq(total_items)
      end

      it 'updates total_price attribute' do
        expect(cart.reload.total_price).to eq(total_price)
      end
    end

    context 'when transaction failed' do
      let(:params) { { total_items: total_items, total_price: total_price } }

      context 'when total_items has negative values' do
        let(:total_items) { -1 }
        let(:total_price) { 0 }

        it 'raises error' do
          expect { cart.update!(params) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when total_price has negative values' do
        let(:total_items) { 0 }
        let(:total_price) { -1.0 }

        it 'raises error' do
          expect { cart.update!(params) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe '#calculate_total_items' do
    subject { cart.calculate_total_items }

    let(:cart) { create(:cart, :with_user) }

    context 'when cart does not have products added' do
      it 'returns an integer value' do
        expect(subject).to be_an(Integer)
      end

      it 'returns zero' do
        expect(subject).to eq(0)
      end
    end

    context 'when cart has products added' do
      let(:cart_product_a) do
        create(:cart_product, cart: cart, product: product_a, quantity: 1)
      end
      let(:cart_product_b) do
        create(:cart_product, cart: cart, product: product_b, quantity: 2)
      end
      let(:product_a) { create(:product) }
      let(:product_b) { create(:product) }

      before do
        cart_product_a
        cart_product_b
      end

      it 'returns an integer value' do
        expect(subject).to be_an(Integer)
      end

      it 'returns the sum of the elements of the cart' do
        total_items = cart_product_a.quantity + cart_product_b.quantity

        expect(subject).to eq(total_items)
      end
    end
  end

  describe '#calculate_total_price' do
    subject { cart.calculate_total_price }

    let(:cart) { create(:cart, :with_user) }

    context 'when cart does not have products added' do
      it 'returns an integer value' do
        expect(subject).to be_an(Integer)
      end

      it 'returns zero' do
        expect(subject).to eq(0)
      end
    end

    context 'when cart has products added' do
      let(:cart_product_a) do
        create(:cart_product, cart: cart, product: product_a, quantity: quantity_a,
                              total_amount: total_amount_a)
      end
      let(:cart_product_b) do
        create(:cart_product, cart: cart, product: product_b, quantity: quantity_b,
                              total_amount: total_amount_b)
      end
      let(:quantity_a) { 1 }
      let(:quantity_b) { 2 }
      let(:product_a) { create(:product) }
      let(:product_b) { create(:product) }
      let(:total_amount_a) { product_a.price * quantity_a }
      let(:total_amount_b) { product_b.price * quantity_b }

      before do
        cart_product_a
        cart_product_b
      end

      it 'returns an integer value' do
        expect(subject).to be_an(Integer)
      end

      it 'returns sum of the products amount of the cart' do
        total_amount = cart_product_a.total_amount + cart_product_b.total_amount

        expect(subject).to eq(total_amount)
      end
    end
  end
end
