class AddAttendeesCountToCourseEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :course_events, :attendees_count, :integer, limit: 2, default: 0, null: false

    reversible do |dir|
      dir.up do
        CourseEvent.find_each { |ce| CourseEvent.reset_counters(ce.id, :attendees_count) }
      end
    end
  end
end
