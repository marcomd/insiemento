class Api::Ui::V1::UserDocumentsController < Api::Ui::BaseController
  skip_before_action :authenticate_request, only: :callback

  respond_to :json

  # PUT from external service to update the state and the sign_checksum
  # Example of a sign checksum: 9d1f97c55893d83fa241ef73fd2612e7
  def callback
    user_document = UserDocument.find_by(uuid: user_document_params[:uuid])
    raise(ActiveRecord::RecordNotFound, "Uuid #{user_document_params[:uuid]} does not exist") unless user_document

    user_document.errors.add(:state, 'State expired does not allow this') if user_document.expired_state?

    user_document.errors.add(:state, "Unexpected state #{params[:state]}") unless UserDocument.states.keys.include?(user_document_params[:state])

    if user_document.errors.empty? && user_document.update(state: user_document_params[:state],
                                                           sign_checksum: user_document_params[:final_checksum])
      render(json: { state: user_document.state }, status: :ok)
    else
      render(json: { errors: user_document.errors }, status: :unprocessable_entity)
    end
  end

  private

  def user_document_params
    params.permit(:uuid, :state, :format, :user_document, :final_checksum)
  end
end
