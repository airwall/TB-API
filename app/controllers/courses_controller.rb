class CoursesController < ApplicationController
  before_action :check_status
  include CoursesHelper

  def index
    render_view(@request_code, @checkpoint)
  end

  private

  def check_status
    @request_code = Course.last&.request_code
    @checkpoint = Course.last&.last_synched_at
  end
end
