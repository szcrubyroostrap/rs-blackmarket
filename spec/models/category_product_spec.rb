require 'rails_helper'

RSpec.describe CategoryProduct, type: :model do
  describe 'database' do
    it 'has columns' do
      expect(subject).to have_db_column(:product_id).of_type(:integer)
      expect(subject).to have_db_column(:category_id).of_type(:integer)
      expect(subject).to have_db_column(:created_at).of_type(:datetime).with_options(null: false)
      expect(subject).to have_db_column(:updated_at).of_type(:datetime).with_options(null: false)
    end

    it 'has indices' do
      expect(subject).to have_db_index(:product_id)
      expect(subject).to have_db_index(:category_id)
    end
  end

  describe 'validations' do
    it 'has relationships' do
      expect(subject).to belong_to(:category)
      expect(subject).to belong_to(:product)
    end
  end
end
