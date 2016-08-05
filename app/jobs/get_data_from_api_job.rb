class GetDataFromApiJob < ApplicationJob
  queue_as :default

  def perform
    Course.save_data_to_db
  end
end
