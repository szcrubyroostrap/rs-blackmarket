require 'rails_helper'

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
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:stock) }

    it { is_expected.to validate_numericality_of(:rating).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:status).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:stock).is_greater_than(0) }

    it 'has relationships' do
      expect(subject).to have_many(:category_products).dependent(:destroy)
    end
  end
end
