class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses, &:timestamps
  end
end
