class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :user_email
      t.string :product_code
      t.date :order_date

      t.timestamps
    end
  end
end
