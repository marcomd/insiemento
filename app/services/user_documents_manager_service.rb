#
# Add new user documents for each user depending on active document models
#
class UserDocumentsManagerService
  prepend SimpleCommand

  attr_reader :debug

  def initialize(debug: false)
    @debug = debug
  end

  def call
    expired_count = UserDocument.to_expire.update_all(state: :expired)
    h_user_documents = []
    UserDocumentModel.active_state.order('id').each do |user_document_model|
      # user_document_model.organization.users.active_state.each do |user|
      user_document_model.organization.users.with_not_ended_subscriptions.elegible_for_user_documents.each do |user|
        last_user_document = user.user_documents.where(user_document_model_id: user_document_model.id).last
        bol_create_user_document =
          if last_user_document
            if last_user_document.expired_state?
              if user_document_model.recurring
                true
              else
                puts "UserDocumentsService user #{user.id} have one document model #{user_document_model.id} which is not recurring" if debug && !Rails.env.test?
                false
              end
            else
              puts "UserDocumentsService user #{user.id} already have document model #{user_document_model.id}" if debug && !Rails.env.test?
              false
            end
          else
            true
          end

        next unless bol_create_user_document

        attributes = {  organization_id: user_document_model.organization_id,
                        user_document_model_id: user_document_model.id,
                        title: user_document_model.title,
                        body: user_document_model.body,
                        user_id: user.id,
                        state: :draft }
        if debug
          Rails.logger.debug { "UserDocument #{attributes}" } unless Rails.env.test?
        else
          h_user_documents << attributes
        end

        # if user.has_active_document?(user_document_model.id)
        #   puts "UserDocumentModel #{user_document_model.id} already present" unless Rails.env.test?
        # else
        #   attributes = {  organization_id: user_document_model.organization_id,
        #                   title: user_document_model.title,
        #                   body: user_document_model.body,
        #                   user_id: user_document_model.user_id,
        #                   state: :draft}
        #   if debug
        #     puts "UserDocument #{attributes}" unless Rails.env.test?
        #   else
        #     h_user_documents << attributes
        #   end
        # end
      end
    end
    UserDocument.create!(h_user_documents) if h_user_documents.present?
    [expired_count, h_user_documents]
  end
end
