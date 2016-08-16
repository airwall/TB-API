module CoursesHelper
  def render_view(request_code, checkpoint)
    if request_code == 200
      @courses = Course.where(access_type: "open").paginate(page: params[:page], per_page: 3)
    elsif request_code == 404
      @courses = Course.where(access_type: "open").paginate(page: 1, per_page: 1)
      flash[:danger] = "At moment Teachbase it's not avaliable. Loaded copy from #{checkpoint.strftime('%Y-%m-%d %H:%M')}."
    elsif request_code.zero?
      @courses = Course.where(access_type: "open").paginate(page: 1, per_page: 1)
      flash[:danger] = "Teachbase is not avaliable #{((Time.now - checkpoint) / 3600).round} hours."
    else
      flash[:danger] = "At moment no open courses."
    end
    render :index
  end
end
