class AddLastSynchedAtToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :last_synched_at, :datetime
  end
end
