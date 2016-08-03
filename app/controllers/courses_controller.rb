class CoursesController < ApplicationController
  # before_action :set_list_api

  def index
    # Course.fetch
    @courses = Course.paginate(:page => params[:page], :per_page => 1)
    render :index
  end
end
