class Category < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products
  belongs_to :parent_category, class_name: 'Category', optional: true

  validates :name, presence: true
end
