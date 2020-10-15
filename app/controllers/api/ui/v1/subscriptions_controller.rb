class Api::Ui::V1::SubscriptionsController < Api::Ui::BaseController
  before_action :set_subscription, except: [:index]

  respond_to :json

  def index
    @subscriptions = current_user.subscriptions
                         .order('id')
                         .includes(:category, :product, attendees: {course_event: [:course, :trainer, :room]})
    # Consente di filtrare tramite https://github.com/activerecord-hackery/ransack
    if params[:q].present?
      @subscriptions = @subscriptions.ransack(params[:q]).result
    else
      # if params[:state].present?
      #   if params[:state].downcase == 'active'
      #     @subscriptions = @subscriptions.where(state: Subscription::ACTIVE_STATES)
      #     #.where('event_date > ?', Time.zone.now+EVENT_TIME_OFFSET)
      #   elsif params[:state].downcase == 'closed'
      #     @subscriptions = @subscriptions.where(state: Subscription::UNACTIVE_STATES)
      #     #.where('event_date < ?', Time.zone.now+EVENT_TIME_OFFSET)
      #   elsif params[:state] == 'ALL'
      #     # Do nothing
      #   else
      #     raise API::Exceptions::BadRequest, "Parameter state '#{params[:state]}' not recognized!"
      #   end
      #   # This params is only used to filter above
      #   params.delete :state
      # end
      @subscriptions = @subscriptions.where(subscription_filter_params)
    end

    render :index
  end

  def show
    render :show
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end

  def subscription_filter_params
    params.permit(:organization_id, :category_id, :product_id, :user_id, :order_id, :code, :start_on, :end_on, :state, :subscription_type, :max_accesses_number)
  end
end
