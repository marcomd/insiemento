class Api::Ui::V1::UserDocumentsController < Api::Ui::BaseController
  skip_before_action :authenticate_request, only: :callback

  respond_to :json

  def callback
    user_document = UserDocument.find_by_uuid(user_document_params[:uuid])
    raise(ActiveRecord::RecordNotFound, "Uuid #{user_document_params[:uuid]} does not exist" ) unless user_document

    if user_document.expired_state?
      user_document.errors.add :state, 'State expired does not allow this'
    end

    if !UserDocument.states.keys.include? user_document_params[:state]
      user_document.errors.add :state, "Unexpected state #{params[:state]}"
    end

    if user_document.errors.empty? && user_document.update(state: user_document_params[:state])
      render json: { state: user_document.state }, status: :ok
    else
      render json: { errors: user_document.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_document_params
    params.permit(:uuid, :state, :format, :user_document)
  end
end
