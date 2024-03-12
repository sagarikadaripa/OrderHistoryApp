class CreateProcessedOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :processed_orders do |t|
       t.references :user, foreign_key: true
       t.text :data
      t.timestamps
    end
  end
end
