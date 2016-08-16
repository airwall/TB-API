class GetDataFromApiJob < ApplicationJob
  queue_as :default

  def perform
    token ||= JSON.parse(RestClient.post("http://s.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                              client_id: Rails.application.secrets.client_id,
                                                                              client_secret: Rails.application.secrets.client_secret))["access_token"]
    content = JSON.parse(RestClient.get("http://s.teachbase.ru/endpoint/v1/course_sessions", "Authorization" => "Bearer #{token}"))

    content.each do |c|
      next unless c["access_type"] == "open"
      id = (c["course"]["id"]).to_i
      if Course.exists?(course_id: id)
        Course.where(course_id: id).each do |u|
          u.touch(:last_synched_at)
          u.update(request_code: 200)
        end
      else
        Course.create(session_name: c["name"],
                      started_at:   c["started_at"],
                      access_type:  c["access_type"],
                      finished_at:  c["finished_at"],
                      apply_url:    c["apply_url"],
                      course_id:    c["course"]["id"],
                      course_name:  c["course"]["name"],
                      owner_name:   c["course"]["owner_name"],
                      description:  c["course"]["description"],
                      last_synched_at: Time.now,
                      request_code: 200)
      end
    end
  rescue
    Course.set_time_delay
  end
end
