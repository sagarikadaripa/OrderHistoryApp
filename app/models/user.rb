class User < ApplicationRecord
  has_many :orders, foreign_key: 'user_email', primary_key: 'email'
  has_many :processed_order

  def process_orders(orders)
    result = []

    orders.each do |order|
      product_code = order.product_code
      product = Product.find_by(code: product_code)

      product_name = product.try(:name) || "Unknown"
      product_category = product.try(:category) || "Unknown"
      order_date = order.order_date

      result << {
        product_code: product_code,
        product_name: product_name,
        product_category: product_category,
        order_date: order_date
      }
    end
    return result
  end
end
