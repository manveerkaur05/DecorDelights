# app/controllers/admin_controller.rb

class AdminController < ApplicationController
  before_action :authenticate_admin

  def dashboard
    @products = Product.all
  end

  def index
    @products = Product.all
  end

  def new_product
    @product = Product.new
  end

  def create_product
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_index_path, notice: "Product created successfully"
    else
      flash.now[:error] = "Failed to create product"
      render :new_product
    end
  end

  def edit_product
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update_product
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_index_path, notice: "Product updated successfully"
    else
      flash.now[:error] = "Failed to update product"
      render :edit_product
    end
  end

  def delete_product
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to admin_index_path, notice: "Product deleted successfully"
    else
      redirect_to admin_index_path, alert: "Failed to delete product"
    end
  end

  def show_product
    @product = Product.find(params[:id])
    @edit_mode = params[:edit].present?
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :category_id, :image_url, :on_sale)
  end

  def authenticate_admin
    redirect_to new_admin_session_path unless current_admin
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def list_users_with_orders
    @users_with_orders = User.includes(:orders).order('users.created_at DESC')
  end

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity

    redirect_to products_path, notice: 'Product added to cart'
  end

  def edit_cart
    product_id = params[:product_id]
    new_quantity = params[:quantity].to_i

    session[:cart][product_id] = new_quantity

    redirect_to cart_path, notice: 'Cart updated'
  end

  def remove_from_cart
    product_id = params[:product_id]
    session[:cart].delete(product_id)

    redirect_to cart_path, notice: 'Product removed from cart'
  end
end

