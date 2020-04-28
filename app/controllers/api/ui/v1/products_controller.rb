class Api::Ui::V1::ProductsController < Api::Ui::BaseController
  before_action :set_product, except: [:index]

  respond_to :json

  def index
    @products = current_organization.products.order('id')
    # Consente di filtrare tramite https://github.com/activerecord-hackery/ransack
    if params[:q].present?
      @products = @products.ransack(params[:q]).result
    else
      @products = @products.where(product_filter_params)
    end

    render :index
  end

  def show
    render :show
  end

  private

  def set_product
    @product = current_organization.products.find(params[:id])
  end

  def product_filter_params
    params.permit(:organization_id, :category_id, :name, :description, :price, :days)
  end
end
