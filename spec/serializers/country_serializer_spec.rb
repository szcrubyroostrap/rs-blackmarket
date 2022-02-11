RSpec.describe CountrySerializer do
  subject { JSON.parse(serialized) }

  let(:country) { create(:country) }

  context 'attributes' do
    let(:serialized) { CountrySerializer.render(country) }

    it { is_expected.to include('id' => country.id) }
    it { is_expected.to include('name' => country.name) }
  end
end
