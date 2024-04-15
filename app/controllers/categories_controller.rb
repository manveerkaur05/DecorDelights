# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  before_action :set_breadcrumbs, except: :index
    def index
      @categories = Category.all
    end
  
    def show
      @category = Category.find(params[:id])
      @products = @category.products
    end
    private

    def set_breadcrumbs
      @breadcrumbs = [
        { name: "Products", url: products_path }
      ]
      @breadcrumbs << { name: @category.name, url: category_path(@category) } if @category
    end
  end
  