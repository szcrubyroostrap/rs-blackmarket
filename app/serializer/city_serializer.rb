class CitySerializer < Blueprinter::Base
  identifier :id

  fields :name

  view :with_associations do
    include_view :country
  end

  view :country do
    association :country, blueprint: CountrySerializer
  end
end
