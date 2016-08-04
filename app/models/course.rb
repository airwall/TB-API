class Course < ApplicationRecord
  cattr_accessor :request
  cattr_accessor :checkpoint

  self.checkpoint = Time.now
  self.request = 200

  def self.save_data_to_db
    token = JSON.parse(@response)["access_token"]
    begin
      content = JSON.parse(RestClient.get("http://.teachbase.ru/endpoint/v1/course_sessions",
                                          "Authorization" => "Bearer #{token}"))
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
    rescue
      self.set_time_delay
    end
  end

  def self.request_delay
    self.checkpoint = Time.now unless request == 404 || 0 # Задаем время начала простоя Teachbase
    begin
      @response = RestClient.post "http://s1.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                      client_id: Rails.application.secrets.client_id,
                                                                      client_secret: Rails.application.secrets.client_secret
      self.request = 200
    rescue
      self.set_time_delay
    end
  end

  def self.set_time_delay
    delay_server = (Time.now - self.checkpoint)
    self.request = (delay_server < 3600 ? 404 : 0)
    # Выдаем сообщение "Teachbase недоступен" если простой меньше часа
    # Выдаем сообщение "Teachbase лежит" если простой больше часа
  end
end
