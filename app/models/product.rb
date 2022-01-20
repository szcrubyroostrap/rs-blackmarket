class Product < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
  has_many :cart_products, dependent: :destroy

  validates :name, :description, :price, :rating, :status, :stock, presence: true
  validates :rating, :status, :stock, numericality: { greater_than_or_equal_to: 0 }

  enum status: { inactive: 0, active: 1 }
end
