class Api::Ui::V1::ProductsController < Api::Ui::BaseController
  before_action :set_organization
  before_action :set_product, except: [:index]

  respond_to :json

  def index
    @products = @organization.products.order('id')
    # Consente di filtrare tramite https://github.com/activerecord-hackery/ransack
    @products = if params[:q].present?
                  @products.ransack(params[:q]).result
                else
                  @products.where(product_filter_params)
                end

    render(:index)
  end

  def show
    render(:show)
  end

  private

  def set_product
    @product = @organization.products.find(params[:id])
  end

  def product_filter_params
    params.permit(:organization_id, :category_id, :name, :description, :price, :days)
  end
end
