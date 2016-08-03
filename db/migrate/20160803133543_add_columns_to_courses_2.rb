class AddColumnsToCourses2 < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :course_id, :integer
  end
end
