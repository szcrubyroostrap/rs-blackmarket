RSpec.describe Address, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:home_address).of_type(:string).with_options(null: false)
      expect(subject).to have_db_column(:zip_code).of_type(:string)
      expect(subject).to have_db_column(:city_id).of_type(:integer).with_options(null: false)
      expect(subject).to have_db_column(:user_id).of_type(:integer).with_options(null: false)
    end
  end

  describe 'associations' do
    it { expect(subject).to belong_to(:city) }
    it { expect(subject).to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:home_address) }
  end
end
