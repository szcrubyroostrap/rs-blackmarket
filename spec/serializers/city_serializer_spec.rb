RSpec.describe CitySerializer do
  subject { JSON.parse(serialized) }

  let(:city) { create(:city) }

  describe 'attributes' do
    let(:serialized) { CitySerializer.render(city) }

    it { is_expected.to include('id' => city.id) }
    it { is_expected.to include('name' => city.name) }
  end

  describe 'view :with_associations' do
    let(:serialized) { CitySerializer.render(city, view: :with_associations) }

    it { is_expected.to include('id' => city.id) }
    it { is_expected.to include('name' => city.name) }
    it {
      is_expected.to include('country' => { 'id' => city.country.id, 'name' => city.country.name })
    }
  end
end
