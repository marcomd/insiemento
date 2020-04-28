class Api::Ui::V1::PaymentsController < Api::Ui::BaseController
  before_action :set_payment, except: [:index, :create]

  respond_to :json

  def index
    @payments = current_user.payments.order('id')
    # Consente di filtrare tramite https://github.com/activerecord-hackery/ransack
    if params[:q].present?
      @payments = @payments.ransack(params[:q]).result
    else
      if params[:state].present?
        if params[:state].downcase == 'active'
          @payments = @payments.where(state: Payment::ACTIVE_STATES)
          #.where('event_date > ?', Time.zone.now+EVENT_TIME_OFFSET)
        elsif params[:state].downcase == 'closed'
          @payments = @payments.where(state: Payment::UNACTIVE_STATES)
          #.where('event_date < ?', Time.zone.now+EVENT_TIME_OFFSET)
        elsif params[:state] == 'ALL'
          # Do nothing
        else
          raise API::Exceptions::BadRequest, "Parameter state '#{params[:state]}' not recognized!"
        end
        # This params is only used to filter above
        params.delete :state
      end
    end

    render :index
  end

  def show
    render :show
  end

  def create
    @payment = current_customer.payments.build(payment_params)

    Payment.transaction do
      if @payment.save
        render :show, status: :created
      else
        render json: { errors: @payment.errors }, status: :unprocessable_entity
      end
    end
  end

  # def update
  #   if @payment.update(payment_params)
  #     render :show, status: :ok
  #   else
  #     render json: { errors: @payment.errors }, status: :unprocessable_entity
  #   end
  # end
  #
  # def destroy
  #   @payment.destroy
  #   head :no_content
  # end

  private

  def set_payment
    @payment = current_user.payments.find(params[:id])
  end

  def payment_filter_params
    params.permit(:user_id, :order_id, :source, :state, :amount)
  end

  def payment_params
    params.require(:payment).permit(
        :user_id, :order_id, :source, :state, :amount
    )
  end
end
