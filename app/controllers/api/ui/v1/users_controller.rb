class Api::Ui::V1::UsersController < Api::Ui::BaseController
  before_action :set_user, except: [:index, :availability]
  skip_before_action :authenticate_request, only: [:availability], raise: false

  respond_to :json

  def show
    render :show
  end

  def update
    if @user.update(user_params)
      render :show, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def availability
    sleep(rand(0.0..0.8)) if Rails.env.development?
    permitted_params = [:email, :format]
    email = params.permit(*permitted_params)[:email]
    if email
      email = URI.decode(email)
    else
      raise(Api::BadRequestError, I18n.t('ui.users.errors.email_required'))
    end
    regexp_email = /\A([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})\Z/
    raise Api::BadRequestError, I18n.t('ui.users.errors.email_invalid_format') unless regexp_email === email

    user = User.find_by_email(email)
    json_attributes = { available: !user }
    render json: json_attributes, status: :ok
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :email_confirmation,
                                 :firstname, :lastname, :birthdate,
                                 :child_firstname, :child_lastname, :child_birthdate,
                                 :phone, :gender, :format)
  end

end
