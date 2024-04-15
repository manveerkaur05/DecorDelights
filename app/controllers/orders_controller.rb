# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
    def new
      @order = Order.new
      @order.cart = session[:cart] || []
    end
  
    def create
      @order = Order.new(order_params)
      @order.total = calculate_total(@order.cart)
      @order.gst, @order.pst, @order.hst = calculate_taxes(@order.total, @order.province)
  
      if @order.save
        flash[:success] = 'Order placed successfully!'
        redirect_to root_path
      else
        render 'new'
      end
    end

    def confirmation
      @order = Order.find(params[:id])
    end
  
    private
  
    def order_params
      params.require(:order).permit(:name, :address, :province)
    end
  
    def calculate_total(cart)
      total = 0
      cart.each do |item|
        total += item[:price] * item[:quantity]
      end
      total
    end
  
    def calculate_taxes(total, province)
      case province
      when 'Alberta', 'Northwest Territories', 'Nunavut', 'Yukon'
        gst = total * 0.05
        pst = 0
        hst = gst
      when 'British Columbia', 'Manitoba', 'Saskatchewan'
        gst = total * 0.05
        pst = total * 0.07
        hst = 0
      when 'New Brunswick', 'Newfoundland and Labrador', 'Nova Scotia', 'Prince Edward Island'
        gst = 0
        pst = 0
        hst = total * 0.15
      when 'Ontario'
        gst = 0
        pst = 0
        hst = total * 0.13
      when 'Quebec'
        gst = total * 0.05
        pst = total * 0.09975 # Quebec PST rate
        hst = gst + pst
      else
        gst = 0
        pst = 0
        hst = 0
      end
      [gst, pst, hst]
    end
  def save_order_items(order)
    order.cart.each do |item|
      order.order_items.create(product_id: item[:product_id], quantity: item[:quantity], price: item[:price])
    end
  end
end
  
