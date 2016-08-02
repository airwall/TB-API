class CoursesController < ApplicationController
  before_action :set_list_api

  def index
    render :index
  end
end
