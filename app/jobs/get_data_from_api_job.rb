class GetDataFromApiJob < ApplicationJob
  queue_as :default

  def perform
    Course.get_content
  end
end
