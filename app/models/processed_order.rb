class ProcessedOrder < ApplicationRecord
  belongs_to :user

  serialize :data, JSON # This will ensure that the data column is serialized as JSON when stored in the database
end
