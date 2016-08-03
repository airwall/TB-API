class Course < ApplicationRecord

  self.per_page = 1
  
  def self.fetch
    response = RestClient.post "http://s1.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                     client_id: Rails.application.secrets.client_id,
                                                                     client_secret: Rails.application.secrets.client_secret

    token = JSON.parse(response)["access_token"]
    content = JSON.parse(RestClient.get("http://s1.teachbase.ru/endpoint/v1/course_sessions", "Authorization" => "Bearer #{token}"))
    self.save_data_to_db(content)
  end

  def self.save_data_to_db(content)
    content.each do |c|
      next unless exists?(course_id: c["course"]["id"]) == false && c["access_type"] == "open"
      create(session_name: c["name"],
             started_at:   c["started_at"],
             access_type:  c["access_type"],
             finished_at:  c["finished_at"],
             apply_url:    c["apply_url"],
             course_id:    c["course"]["id"],
             course_name:  c["course"]["name"],
             owner_name:   c["course"]["owner_name"],
             cower_url:    c["course"]["cower_url"],
             description:  c["course"]["description"])
    end
  end
end
