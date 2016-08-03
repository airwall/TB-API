class CoursesController < ApplicationController
  # before_action :set_list_api

  def index
    Course.fetch
    @content = Course.all
    render :index
  end
end
