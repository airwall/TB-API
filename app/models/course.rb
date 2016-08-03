class Course < ApplicationRecord
  cattr_accessor :request
  cattr_accessor :checkpoint

  # Дефолтное значение на случай если keep_status_request не отработал ни разу
  self.checkpoint = Time.now
  self.request = 200

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

  def self.request_delay
    self.checkpoint = Time.now unless request == 404 || 0 # Задаем время начала простоя Teachbase
    begin
      response = RestClient.post "http://s.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                      client_id: Rails.application.secrets.client_id,
                                                                      client_secret: Rails.application.secrets.client_secret
      self.request = 200
      token = JSON.parse(response)["access_token"]
      content = JSON.parse(RestClient.get("http://s1.teachbase.ru/endpoint/v1/course_sessions", "Authorization" => "Bearer #{token}"))
      save_data_to_db(content)
    rescue
      # Расчитываем время простоя
      delay_server = (checkpoint - Time.now).to_i.abs
      # Выдаем сообщение "Teachbase недоступен" если простой меньше часа
      # Выдаем сообщение "Teachbase лежит" если простой больше часа
      self.request = (delay_server < 3600 ? 404 : 0)
      self
    end
  end
end
