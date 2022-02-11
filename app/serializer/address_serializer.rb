class AddressSerializer < Blueprinter::Base
  identifier :id

  fields :home_address, :zip_code

  view :with_associations do
    include_view :assignations
  end

  view :assignations do
    association :user, blueprint: UserSerializer
    association :city, view: :with_associations, blueprint: CitySerializer
  end
end
