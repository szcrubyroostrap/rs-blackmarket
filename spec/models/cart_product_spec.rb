RSpec.describe CartProduct, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:quantity).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:total_amount).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:cart_id).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:product_id).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(null: false)
      expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)
    end

    it 'has indexes' do
      expect(subject).to have_db_index(:cart_id)
      expect(subject).to have_db_index(:product_id)
    end
  end

  describe 'associations' do
    it { expect(subject).to belong_to(:cart) }
    it { expect(subject).to belong_to(:product) }
  end

  describe 'validations' do
    context 'when is an attribute supervision' do
      it { is_expected.to validate_presence_of(:quantity) }
      it { is_expected.to validate_presence_of(:total_amount) }
      it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:total_amount).is_greater_than_or_equal_to(0) }
    end

    context 'when is a supervision with the product' do
      let(:cart_product) { build(:cart_product, product: product, cart: cart, quantity: quantity) }
      let(:cart) { create(:cart, :with_user) }
      let(:quantity) { 5 }

      context 'when is an active product' do
        let(:product) { create(:product) }

        it 'is a valid record' do
          expect(cart_product.valid?).to be_truthy
        end
      end

      context 'when is an inactive product' do
        let(:product) { create(:product, status: 0) }

        it 'raises an error' do
          expect { cart_product.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context 'when product has enough stock' do
        let(:product) { create(:product) }

        it 'is a valid record' do
          expect(cart_product.valid?).to be_truthy
        end
      end

      context 'when product does not have enough stock' do
        let(:product) { create(:product, stock: 1) }

        it 'raises an error' do
          expect { cart_product.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe '#create' do
    let(:cart_product) { build(:cart_product, product: product, cart: cart, quantity: quantity) }
    let(:cart) { create(:cart, :with_user) }
    let(:quantity) { 5 }

    context 'when transaction is successful' do
      let(:product) { create(:product) }

      it 'is saved in database' do
        expect { cart_product.save! }.to change { CartProduct.count }.by(1)
      end
    end

    context 'when is an invalid record' do
      let(:product) { create(:product, stock: 0) }

      it 'is saved in database' do
        expect { cart_product.save }.to change { CartProduct.count }.by(0)
      end
    end
  end

  describe '#update' do
    let(:cart_product) { create(:cart_product, product: product, cart: cart, quantity: quantity) }
    let(:cart) { create(:cart, :with_user) }
    let(:product) { create(:product) }

    context 'when transaction is successful' do
      let(:quantity) { 5 }

      before do
        cart_product.update!(quantity: quantity)
      end

      it 'updates quantity attribute' do
        expect(cart_product.reload.quantity).to eq(quantity)
      end
    end

    context 'when transaction failed' do
      context 'when quantity attribute exceeds the stock of the product' do
        let(:quantity) { 100 }

        it 'raises error' do
          expect { cart_product.update!(params) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
