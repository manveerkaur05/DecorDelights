# app/controllers/pages_controller.rb
class PagesController < ApplicationController
    def home
      @categories = Category.all
      @products = Product.all
    end
  end
  