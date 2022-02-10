RSpec.describe Country, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:name).of_type(:string).with_options(null: false)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    context 'when validating unique values' do
      subject { create(:country) }

      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
