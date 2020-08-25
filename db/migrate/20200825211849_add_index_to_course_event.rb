class AddIndexToCourseEvent < ActiveRecord::Migration[6.0]
  def change
    add_index :course_events, :state
    add_index :course_events, :event_date
    change_column_null(:system_logs, :organization_id, true)
  end
end
