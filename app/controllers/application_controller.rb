class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_list_api
    client_id = 'f2289ec45da71c85f7841f3760bc0b7426e18ca63f3167c00ed77643b199d39e'
    client_secret = 'bb7966f39349a2406c6d428f134c52bc71d4e4c53565ddb97efd7fa078a97090'

    response = RestClient.post 'http://s1.teachbase.ru/oauth/token', {
      grant_type: 'client_credentials',
      client_id: client_id,
      client_secret: client_secret,
    }

    token = JSON.parse(response)["access_token"]

    @content = RestClient.get 'http://s1.teachbase.ru/endpoint/v1/course_sessions', { 'Authorization' => "Bearer #{token}" }

  end


end
