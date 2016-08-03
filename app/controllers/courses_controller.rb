class CoursesController < ApplicationController
  def index
    Course.request_delay
    @request = Course.request
    if @request == 200
      @courses = Course.paginate(page: params[:page], per_page: 1)
    elsif @request == 404
      @courses = Course.paginate(page: 1, per_page: 1)
      @alert = "В данный момент Teachbase недоступен. Загружена копия от #{Course.checkpoint}"
    else
      @courses = Course.paginate(page: 1, per_page: 1)
      @alert = "Teachbase лежит уже #{((Time.now - Course.checkpoint).to_i.abs / 60).round} часов"
    end
    render :index
  end
end
