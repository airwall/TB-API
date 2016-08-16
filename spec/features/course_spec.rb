require "rails_helper"

feature "All users can see list of courses", type: :feature do
  describe "if api respond" do
    let(:courses) { create_list(:course, 6) }
    scenario "view list of courses" do
      visit root_path(courses)
      expect(page).to have_content courses.first.description
      expect(page).to have_link "Next"
      click_on "Next"
      expect(page).to have_content courses.last.description
    end
  end

  describe "if api not respond < 1hour" do
    let(:course) { create(:course_404) }
    scenario "view list of courses" do
      checkpoint = course.last_synched_at
      visit root_path(course)
      expect(page).to have_content course.description
      expect(page).to_not have_link "Next"
      expect(page).to have_content "At moment Teachbase it's not avaliable. Loaded copy from #{checkpoint.strftime('%Y-%m-%d %H:%M')}."
    end
  end

  describe "if api not respond < 1hour" do
    let(:course) { create(:course_0) }
    scenario "view list of courses" do
      visit root_path(course)
      expect(page).to have_content course.description
      expect(page).to_not have_link "Next"
      checkpoint = course.last_synched_at
      expect(page).to have_content "Teachbase is not avaliable #{((Time.now - checkpoint) / 3600).round} hours."
    end
  end

  describe "if api not respond < 1hour" do
    let(:course) { create(:course, request_code: 500) }
    scenario "view list of courses" do
      visit root_path(course)
      expect(page).to_not have_content course.description
      expect(page).to_not have_link "Next"
      expect(page).to have_content "At moment no open courses."
    end
  end
end
