class ChangeColumnRequestCodeDefault200 < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :request_code, :integer, default: 200
    remove_column :courses, :request_token
  end
end
