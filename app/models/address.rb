class Address < ApplicationRecord
  belongs_to :city
  belongs_to :user

  validates :home_address, presence: true
end
