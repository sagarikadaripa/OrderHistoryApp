namespace :import do
  desc "Import data from CSV files"
  task :data => :environment do
    require 'csv'

    # Import Users
    CSV.foreach(Rails.root.join('dataset', 'users.csv'), headers: true) do |row|
      user_data = row.to_hash.transform_keys(&:underscore)
      User.create(user_data)
    end

    # # Import Products
    CSV.foreach(Rails.root.join('dataset', 'products.csv'), headers: true) do |row|
      product_data = row.to_hash.transform_keys(&:underscore)
      Product.create(product_data)
    end

    # Import Orders
    CSV.foreach(Rails.root.join('dataset', 'order_details.csv'), headers: true) do |row|

      order_data = row.to_hash.transform_keys(&:underscore)
      order_data['order_date'] = Date.parse(order_data['order_date'])
      Order.create(order_data)
    end
  end
end
