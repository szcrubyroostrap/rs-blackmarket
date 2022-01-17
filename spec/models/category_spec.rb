RSpec.describe Category, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:name).of_type(:string).with_options(null: false)
      expect(subject).to have_db_column(:parent_category_id).of_type(:integer)
      expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(null: false)
      expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)
    end

    it 'has indices' do
      expect(subject).to have_db_index(:parent_category_id)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it 'has relationships' do
      expect(subject).to have_many(:category_products).dependent(:destroy)
      expect(subject).to have_many(:products).through(:category_products)
      expect(subject).to belong_to(:parent_category).optional
    end
  end
end
