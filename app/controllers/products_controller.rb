# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  before_action :set_breadcrumbs, only: [:index, :show]

  def index
    @products = Product.all
    
    if params[:on_sale]
      @products = @products.on_sale
    elsif params[:new_products]
      @products = @products.new_products
    elsif params[:recently_updated]
      @products = @products.recently_updated
    end

    # Additional filtering based on keyword and category
    @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") if params[:keyword].present?
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    @products = @products.page(params[:page]).per(5)
  end

  def show
    @product = Product.find(params[:id])
    @category = @product.category
  end

  def add_to_cart
    product_id = params[:product_id]
    session[:cart] ||= []
    session[:cart] << product_id
    redirect_to products_path, notice: "Product added to cart successfully"
  end

  private

  def set_breadcrumbs
    @breadcrumbs = [
      { name: "Products", url: products_path }
    ]
    if @category
      @breadcrumbs << { name: @category.name, url: category_path(@category) }
    end
    @breadcrumbs << { name: @product.name, url: product_path(@product) } if @product
  end
end


