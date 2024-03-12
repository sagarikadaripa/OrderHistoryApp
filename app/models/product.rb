class Product < ApplicationRecord
  has_many :orders, foreign_key: 'product_code', primary_key: 'code'
end
