class CountrySerializer < Blueprinter::Base
  identifier :id

  fields :name

  view :with_resume do
    field :name
  end
end
