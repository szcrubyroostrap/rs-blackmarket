class City < ApplicationRecord
  belongs_to :country
  has_many :addresses, dependent: :destroy

  validates :name, presence: true
end
