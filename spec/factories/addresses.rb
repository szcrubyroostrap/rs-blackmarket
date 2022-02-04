FactoryBot.define do
  factory :address do
    home_address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { create(:city) }
    user { create(:user) }
  end
end
