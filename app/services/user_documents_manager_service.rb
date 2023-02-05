#
# Add new user documents for each user depending on active document models
#
# rubocop:disable Metrics/AbcSize
class UserDocumentsManagerService
  prepend SimpleCommand

  attr_reader :debug

  def initialize(debug: false)
    @debug = debug
  end

  def call
    expired_count = UserDocument.to_expire.update_all(state: :expired)
    h_user_documents = []

    UserDocumentModel.active_state.order('id').find_each do |user_document_model|
      user_document_model.organization.users.with_not_ended_subscriptions.elegible_for_user_documents.find_each do |user|
        last_user_document = user.user_documents.where(user_document_model_id: user_document_model.id).last
        next unless last_user_document.blank? || (last_user_document.expired_state? && user_document_model.recurring)

        attributes = {  organization_id: user_document_model.organization_id,
                        user_document_model_id: user_document_model.id,
                        title: user_document_model.title,
                        body: user_document_model.body,
                        user_id: user.id,
                        state: :draft }
        if debug
          puts "UserDocument #{attributes}" unless Rails.env.test?
          nil
        else
          h_user_documents << attributes
        end
      end
    end
    UserDocument.create!(h_user_documents) if h_user_documents.present?
    [expired_count, h_user_documents]
  end
end
# rubocop:enable Metrics/AbcSize
