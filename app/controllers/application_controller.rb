class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_list_api
    response = RestClient.post 'http://s1.teachbase.ru/oauth/token', {
      grant_type: 'client_credentials',
      client_id: Rails.application.secrets.client_id,
      client_secret: Rails.application.secrets.client_secret
    }

    token = JSON.parse(response)["access_token"]
    @content = JSON.parse(RestClient.get 'http://s1.teachbase.ru/endpoint/v1/course_sessions', { 'Authorization' => "Bearer #{token}" })

  end
end
