class Country < ApplicationRecord
  has_many :cities, dependent: :destroy

  validates :name, presence: true
end
