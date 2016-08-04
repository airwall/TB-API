class Course < ApplicationRecord

  RequestServerStatusJob.set(wait: 1.minutes).perform_later

  def self.save_data_to_db
    begin
      content = JSON.parse(RestClient.get("http://s1.teachbase.ru/endpoint/v1/course_sessions", "Authorization" => "Bearer #{@token}"))
      content.each do |c|
        next unless c["access_type"] == "open"
          if exists?(course_id: c["course"]["id"])
            c.touch(:last_synched_at)
            c.update(request_code: 200)
          else
            create(session_name: c["name"],
                   started_at:   c["started_at"],
                   access_type:  c["access_type"],
                   finished_at:  c["finished_at"],
                   apply_url:    c["apply_url"],
                   course_id:    c["course"]["id"],
                   course_name:  c["course"]["name"],
                   owner_name:   c["course"]["owner_name"],
                   cower_url:    c["course"]["cower_url"],
                   description:  c["course"]["description"],
                   session_id:   c["id"],
                   last_synched_at: Time.now,
                   request_code: 200)
          end
      end
      where(access_type: "rescue").destroy! if exists?(access_type: "rescue")
    rescue
      self.request_token
    end
  end

  def self.request_token
    begin
      response = RestClient.post "http://s1.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                       client_id: Rails.application.secrets.client_id,
                                                                       client_secret: Rails.application.secrets.client_secret
      @token = JSON.parse(response)["access_token"]
      self.save_data_to_db
    rescue
      self.set_time_delay
    end
  end

  def self.set_time_delay
    if count != 0
      delay_server = (Time.now - last&.last_synched_at)
      request_code = delay_server < 5 ? 404 : 0
      last&.update(request_code: request_code)
    else
      create(request_code: 404, last_synched_at: Time.now, access_type: "rescue")
    end
  end
end
