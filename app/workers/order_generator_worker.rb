class OrderGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options concurrency: 1, backtrace: true

  def perform(user_id)
    user = User.find_by(id: user_id)
    orders = user.orders
    results = user.process_orders(orders)
    ProcessedOrder.create(
      user_id: user_id,
      data: results.to_json
    ) # Store processed order data
  rescue Exception => e
    puts "Trace of Error - #{e.message}"
    puts "Trace of Error - #{e.backtrace.join("\n")}"
  end
end
