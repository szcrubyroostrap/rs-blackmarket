require 'rails_helper'

describe User do
  describe 'Validations' do
    subject { build :user }
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe '#create' do
    let(:params) { attributes_for(:user) }

    context 'successful' do
      it 'is valid' do
        expect(build(:user, params).valid?).to eq(true)
      end
      it 'does not have no errors' do
        user = build(:user, params)
        user.valid?
        expect(user.errors).to be_empty
      end
      it 'saved' do
        expect { create(:user, params) }.to change { User.count }.by(1)
      end
    end

    context 'failed' do
      let!(:user) { create(:user, params) }

      it 'is not valid' do
        expect(build(:user, params).valid?).to eq(false)
      end
      it 'has errors' do
        new_user = build(:user, params)
        new_user.valid?
        expect(new_user.errors).not_to be_empty
      end
      it 'does not save it' do
        expect { User.create(params) }.not_to change { User.count }
      end
    end
  end
end
