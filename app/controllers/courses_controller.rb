class CoursesController < ApplicationController
  # before_action :set_list_api

  def index
    @content = Course.fetch
    render :index
  end
end
