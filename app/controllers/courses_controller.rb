class CoursesController < ApplicationController
  before_action :check_status

  def index
    if @request_code == 200
      @courses = Course.where(access_type: "open").paginate(page: params[:page], per_page: 3)
    elsif @request_code == 404
      @courses = Course.where(access_type: "open").paginate(page: 1, per_page: 1)
      flash[:danger] = "В данный момент Teachbase недоступен. Загружена копия от #{@checkpoint.strftime("%Y-%m-%d %H:%M")}."
    elsif @request_code == 0
      @courses = Course.where(access_type: "open").paginate(page: 1, per_page: 1)
      flash[:danger] = "Teachbase лежит уже #{((Time.now - @checkpoint) / 3600).round} часов."
    else
      flash[:danger] = "Сервис недоступен. Попытайтесь позже!"
    end
    render :index
  end


  private

  def check_status
    @request_code = Course.last&.request_code
    @checkpoint = Course.last&.last_synched_at
  end
end
