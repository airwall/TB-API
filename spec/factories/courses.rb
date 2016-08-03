FactoryGirl.define do
  factory :course do
    session_name "Course name"
    access_type  "open"
    course_id   104
    course_name "Course name"
    owner_name "Owner name"
    description "Description"
    started_at "2016-07"
    finished_at "2016-09"
    apply_url "url"
    cower_url "url"
  end
end
