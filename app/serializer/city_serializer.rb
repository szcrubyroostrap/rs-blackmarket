class CitySerializer < Blueprinter::Base
  identifier :id

  fields :name

  view :with_country do
    include_view :country
  end

  view :country do
    association :country, view: :with_resume, blueprint: CountrySerializer
  end
end
