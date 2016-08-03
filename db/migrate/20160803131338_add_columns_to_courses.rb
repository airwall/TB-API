class AddColumnsToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :session_name, :string
    add_column :courses, :started_at, :datetime
    add_column :courses, :access_type, :string
    add_column :courses, :finished_at, :datetime
    add_column :courses, :apply_url, :string
    add_column :courses, :course_name, :string
    add_column :courses, :owner_name, :string
    add_column :courses, :cower_url, :string
    add_column :courses, :description, :string
  end
end
