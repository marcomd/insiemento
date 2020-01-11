class CourseEventComment < ApplicationRecord
  belongs_to :user
  belongs_to :course_event
end
