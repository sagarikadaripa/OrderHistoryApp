class ProcessedOrderFetcherWorker
  include Sidekiq::Worker
  sidekiq_options concurrency: 1, backtrace: true

  def perform(user_id)
    user = User.find_by(id: user_id)
    processed_order = ProcessedOrder.find_by(user_id: user_id)
    return unless processed_order

    JSON.parse(processed_order.data)
  end
end
