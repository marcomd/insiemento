class ScheduleJob < ApplicationJob
  queue_as :course_events

  def perform
    service = ScheduleService.call
    SystemLog.create!(message: "ScheduleJob success: #{service.success} #{service.errors}") unless service.success
  rescue
    SystemLog.create!(message: "ScheduleJob failed: #{$!.message}")
  end
end
