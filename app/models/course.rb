class Course < ApplicationRecord
  
#   .get_content - Если токен существует, посылает get запрос к API и возвращает json или
#   запускает метод .request_token
#   Если json вернулся отправляет его в .save_data_to_db.

#   .save_data_to_db - Проверяет наличие открытых курсов. Если такие есть то проверяет два сценария
#     1. Если курс существует в базе - синхронизирует время обновления с текущим временем.
#     2. Если курс существует в базе - сохраняет его.

#   .request_token - отправляет post и возвращает токен. При не успешно запросе отправляет к .set_time_delay

#   .set_time_delay - Расчитывает время простоя Teachbase и в зависимости от времени простоя задает
#   соответсвующий времни простоя request_code. request_code используется в котнтроллере для отоброжения
#   нужного нам вида.

  GetDataFromApiJob.set(wait: 1.hours).perform_later

  def self.get_content
    begin
      content = JSON.parse(RestClient.get("http://s1.teachbase.ru/endpoint/v1/course_sessions", "Authorization" => "Bearer #{@token}"))
      self.save_data_to_db(content)
    rescue
      self.request_token
    end
  end

  def self.save_data_to_db(content)
      content.each do |c|
        next unless c["access_type"] == "open"
          id = (c["course"]["id"]).to_i
          if self.exists?(course_id: id)
            self.where(course_id: id).each do |u|
              u.touch(:last_synched_at)
              u.update(request_code: 200)
            end
          else
          create(session_name: c["name"],
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
  end

  def self.request_token
    begin
      response = RestClient.post "http://s1.teachbase.ru/oauth/token", grant_type: "client_credentials",
                                                                       client_id: Rails.application.secrets.client_id,
                                                                       client_secret: Rails.application.secrets.client_secret
      @token = JSON.parse(response)["access_token"]
      self.get_content
    rescue
      self.set_time_delay
    end
  end

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
