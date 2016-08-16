class Course < ApplicationRecord

  def self.set_time_delay
    begin
      delay_server = (Time.now - last&.last_synched_at)
      request_code = delay_server < 4500 ? 404 : 0
      last&.update(request_code: request_code)
    rescue
      where(access_type: "rescue").destroy! if exists?(access_type: "rescue")
      create(request_code: 500, last_synched_at: Time.now, access_type: "rescue")
    end
  end
end
