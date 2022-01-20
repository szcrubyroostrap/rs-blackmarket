RSpec.describe Product, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:name).of_type(:string).with_options(null: false)
      expect(subject).to have_db_column(:description).of_type(:text).with_options(null: false)
      expect(subject).to have_db_column(:price).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:rating).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:status).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:stock).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(null: false)
      expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)
    end
  end

  describe 'validations' do
    it 'validates the name attribute' do
      is_expected.to validate_presence_of(:name)
    end

    it 'validates the description attribute' do
      is_expected.to validate_presence_of(:description)
    end

    it 'validates the price attribute' do
      is_expected.to validate_presence_of(:price)
    end

    it 'validates the rating attribute' do
      is_expected.to validate_presence_of(:rating)
    end

    it 'validates the status attribute' do
      is_expected.to validate_presence_of(:status)
    end

    it 'validates the stock attribute' do
      is_expected.to validate_presence_of(:stock)
    end

    it 'validates the rating attribute is greater than 0' do
      is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(0)
    end

    it 'validates the rating status is an enumerator' do
      is_expected.to define_enum_for(:status).with_values(inactive: 0, active: 1)
    end

    it 'validates the rating attribute is greater than 0' do
      is_expected.to validate_numericality_of(:stock).is_greater_than_or_equal_to(0)
    end
  end

  describe 'associations' do
    it 'has relationships' do
      expect(subject).to have_many(:category_products).dependent(:destroy)
      expect(subject).to have_many(:categories).through(:category_products)
      expect(subject).to have_many(:cart_products).dependent(:destroy)
    end
  end
end
