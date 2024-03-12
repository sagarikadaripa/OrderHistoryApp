class Order < ApplicationRecord
  belongs_to :user, foreign_key: 'user_email', primary_key: 'email'
  belongs_to :product, foreign_key: 'product_code', primary_key: 'code'
end
