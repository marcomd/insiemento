class Product < ApplicationRecord
  belongs_to :organization
  belongs_to :category
  has_many :order_products
  has_many :order, through: :order_products

  monetize :price_cents

  # It uses comma as thousand separator
  ransacker :price, formatter: proc { |v| v.sub(',','.').to_r * 100 } do |parent|
    parent.table[:price_cents]
  end
end
