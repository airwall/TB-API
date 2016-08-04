class AddRequestCodeAtToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :request_token, :integer, default: nil
  end
end
