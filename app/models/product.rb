class Product < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products

  validates :name, :description, :price, :rating, :status, :stock, presence: true
  validates :rating, :status, :stock, numericality: { greater_than: 0 }

  enum status: { inactive: 0, active: 1 }
end
