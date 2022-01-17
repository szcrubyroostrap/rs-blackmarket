class Product < ApplicationRecord
  has_many :category_products, dependent: :destroy

  validates :name, :description, :price, :rating, :status, :stock, presence: true
  validates :rating, :status, :stock, numericality: { greater_than: 0 }
end
