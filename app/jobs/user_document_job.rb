class UserDocumentJob < ApplicationJob
  queue_as :user_documents
  # include Sidekiq::Worker
  # sidekiq_options retry: 5

  def perform(user_document)
    user_document.work!
    user = user_document.user
    params = {
               customer_dossier_id: user_document.id,
               recipients: [
                   {first_name: user.firstname, last_name: user.lastname, email: user.email, phone_number: user.phone, language: 'it' }
               ],
               unsigned_document: {
                   filename: "#{user_document.title&.parameterize&.underscore || 'file'}.pdf",
                   content: user_document.base64_pdf,
                   sign_points: [
                       { key: 'key_1', label: 'Terms and conditions', page: 1, top: 60, left: 46, required: true }
                   ]
               }
    }
    service = OtpService.call(operation: :create, params: params)
    if service.success?
      user_document.otpservice_created!
    else
      message = "UserDocumentJob failed: #{service.errors}"
      SystemLog.create!(message: message, log_level: :error)
      raise message unless service.success?
    end
  end
end
