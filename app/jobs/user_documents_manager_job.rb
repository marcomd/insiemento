class UserDocumentsManagerJob < ApplicationJob
  queue_as :user_documents

  def perform
    service = UserDocumentsManagerService.call
    unless service.success?
      SystemLog.create!(message: "UserDocumentsManagerJob success: #{service.success?} #{service.errors}")
    end
  end
end
