class Api::Ui::V1::OrdersController < Api::Ui::BaseController
  before_action :set_order, except: [:index, :create]

  respond_to :json

  def index
    # To simulate a network delay...
    simulate_delay_for_development
    @orders = current_user.orders.order('id')
    # Consente di filtrare tramite https://github.com/activerecord-hackery/ransack
    if params[:q].present?
      @orders = @orders.ransack(params[:q]).result
    else
      if params[:state].present?
        if params[:state].downcase == 'active'
          @orders = @orders.where(state: Order::ACTIVE_STATES)
          #.where('event_date > ?', Time.zone.now+EVENT_TIME_OFFSET)
        elsif params[:state].downcase == 'closed'
          @orders = @orders.where(state: Order::UNACTIVE_STATES)
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
    products = Product.find(order_params[:product_ids])
    @order = current_user.orders.build(order_params)
    @order.products = products
    @order.organization_id = current_user.organization_id

    Order.transaction do
      if @order.save
        render :show, status: :created
      else
        render json: { errors: @order.errors }, status: :unprocessable_entity
      end
    end
  end

  def update
    if @order.update(order_params)
      render :show, status: :ok
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  end

  # def add_product
  #   raise(ActionController::ParameterMissing, :product_id) unless params[:product_id].present?
  #   product_id = params[:product_id].to_i
  #   raise(Api::BadRequestError, "Product #{product_id} already exists") if @order.order_products.where(product_id: product_id).exists?
  #   product = Product.find(product_id)
  #   if @order.products << product
  #     render :show, status: :ok
  #   else
  #     render json: { errors: @order.errors }, status: :unprocessable_entity
  #   end
  # end
  #
  # def remove_product
  #   raise(ActionController::ParameterMissing, :product_id) unless params[:product_id].present?
  #   product_id = params[:product_id].to_i
  #   order_product = @order.order_products.where(product_id: product_id).first
  #   raise(Api::BadRequestError, "Product #{product_id} cannot be removed because it is not present") unless order_product
  #   if order_product.destroy!
  #     render :show, status: :ok
  #   else
  #     render json: { errors: @order.errors }, status: :unprocessable_entity
  #   end
  # end

  def destroy
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_filter_params
    params.permit(:state, :user_id)
  end

  def order_params
    params.require(:order).permit(
        :currency, :start_on, product_ids: [],
    )
  end
end
