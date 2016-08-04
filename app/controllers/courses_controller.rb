class CoursesController < ApplicationController
  before_action :check_status_load_data

  def index
    if @request == 200
      @courses = Course.paginate(page: params[:page], per_page: 1)
    elsif @request == 404
      @courses = Course.paginate(page: 1, per_page: 1)
      @alert = "В данный момент Teachbase недоступен. Загружена копия от #{Course.checkpoint.strftime("%Y-%m-%d %H:%M")}."
    else
      @courses = Course.paginate(page: 1, per_page: 1)
      @alert = "Teachbase лежит уже #{((Time.now - Course.checkpoint) / 3600).round} часов."
    end
    render :index
  end


  private

  def check_status_load_data
    Course.request_delay
    Course.save_data_to_db if Course.request == 200
    @request = Course.request
  end
end
