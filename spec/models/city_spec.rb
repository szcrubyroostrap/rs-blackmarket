RSpec.describe City, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:name).of_type(:string).with_options(null: false)
      expect(subject).to have_db_column(:country_id).of_type(:integer).with_options(null: false)
    end
  end

  describe 'associations' do
    it { expect(subject).to belong_to(:country) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
