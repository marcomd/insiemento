class Product < ApplicationRecord
  belongs_to :organization
  belongs_to :category

  monetize :price_cents
end
