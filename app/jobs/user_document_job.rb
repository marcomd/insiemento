class UserDocumentJob < ApplicationJob
  queue_as :user_documents
  # include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(user_document)
    user_document.start_export!
    user = user_document.user
    params = {
      customer_dossier_id: user_document.id,
      customer_contract_hash: user_document.uuid,
      # TODO: add phone prefix management on user model
      recipients: [
        { first_name: user.firstname,
          last_name: user.lastname,
          email: user.email,
          phone_prefix: '39',
          phone_number: user.phone&.gsub('+39', ''),
          language: 'it' },
      ],
      unsigned_document: {
        filename: "#{user_document.title&.parameterize&.underscore || 'file'}.pdf",
        content: user_document.base64_pdf,
        sign_points: [
          { key: 'acceptance', label: 'Accetto', page: 1, top: 58, left: 45, required: true },
        ],
      },
      callback_states: %i[signed completed],
    }
    service = OtpService.call(operation: :create, params:)
    if service.success?
      user_document.created_on_otpservice!
    else
      message = "UserDocumentJob failed: #{service.errors}"
      SystemLog.create!(message:, log_level: :error, organization_id: user_document.organization_id)
      user_document.error_on_otpservice!
      raise(message)
    end
  end
end
