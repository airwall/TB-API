FactoryGirl.define do
  sequence :description do |n|
    "Description #{n}"
  end

  sequence :course_name do |n|
    "Course name #{n}"
  end

  factory :course do
    session_name "Session name"
    access_type  "open"
    course_id 104
    course_name
    owner_name "Owner name"
    description
    started_at "2016-07"
    finished_at "2016-09"
    apply_url "url"
    request_code 200
  end

  factory :course_404, class: "Course" do
    session_name "Session name"
    access_type  "open"
    course_id 104
    course_name
    owner_name "Owner name"
    description
    started_at "2016-07"
    finished_at "2016-09"
    apply_url "url"
    last_synched_at Time.now
    request_code 404
  end

  factory :course_0, class: "Course" do
    session_name "Session name"
    access_type  "open"
    course_id 104
    course_name
    owner_name "Owner name"
    description
    started_at "2016-07"
    finished_at "2016-09"
    apply_url "url"
    last_synched_at Time.now
    request_code 0
  end

end
