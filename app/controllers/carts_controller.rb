class CartsController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]

  helper_method :calculate_taxes, :item_total_with_tax, :total_tax_rate

  def show
    @cart_items = load_cart_items
  end

  def add_to_cart
    product_id = params[:product_id]
    session[:cart] ||= []
    session[:cart] << product_id
    
    # Ensure session[:cart_quantity] is initialized
    session[:cart_quantity] ||= Hash.new(0)
    
    # Increment quantity only if it's not nil
    if session[:cart_quantity][product_id].present?
      session[:cart_quantity][product_id] += 1
    else
      session[:cart_quantity][product_id] = 1
    end
    flash[:notice] = "Product sucessfully added to cart "
    
    redirect_to products_path
  end
  

  def update_quantity
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    session[:cart_quantity][product_id] = quantity if quantity.positive?
    redirect_to cart_path, notice: "Cart updated"
  end

  def remove_from_cart
    product_id = params[:product_id]
    session[:cart].delete(product_id)
    session[:cart_quantity].delete(product_id)
    redirect_to cart_path, notice: "Product removed from cart"
  end

  def checkout
    @user = current_user
    @province_name = @user.province.name
    @province_options = province_options
    @cart_items = load_cart_items
    @subtotal = calculate_subtotal(@cart_items)
    @taxes = calculate_taxes(@subtotal, @user.province)
    @total = @subtotal + @taxes[:total_price]
    @invoice = generate_invoice(@cart_items, @subtotal, @taxes)
    puts "Invoice Items: #{@invoice[:items].inspect}"
    puts "Invoice Taxes: #{@invoice[:taxes]}"
  end

  def complete_checkout
    @user = current_user
    @cart_items = load_cart_items
    @subtotal = calculate_subtotal(@cart_items)
    @taxes = calculate_taxes(@subtotal, @user.province)
    
    order = @user.orders.build(subtotal: @subtotal, gst: @taxes[:gst], pst: @taxes[:pst], hst: @taxes[:hst])

    if order.save
      @cart_items.each do |item|
        order.order_items.create(product_id: item[:product].id, quantity: item[:quantity])
      end
      clear_cart
      redirect_to root_path, notice: "Order placed successfully"
    else
      redirect_to cart_path, alert: "Failed to place order"
    end
  end

  private

  def item_total_with_tax(item, province)
    price = item[:product].price
    quantity = item[:quantity]
    total_price_with_tax = price * quantity * (1 + total_tax_rate(province))
    total_price_with_tax
  end

  def load_cart_items
    if session[:cart].present?
      session[:cart].map do |product_id|
        { product: Product.find(product_id), quantity: session[:cart_quantity][product_id] }
      end
    else
      []
    end
  end

  def calculate_subtotal(cart_items)
    cart_items.sum { |item| item[:product].price * item[:quantity] }
  end
 

  def calculate_taxes(subtotal, province)
    puts "===========calculate_taxes=========="
    puts "SQL Query: #{TaxRate.where(province: province).to_sql}"
    province_tax_rates = TaxRate.find_by_id(province)
    puts "Province Tax Rates: #{province_tax_rates.inspect}" # Debug print
    
    if province_tax_rates.present?
      total_gst = subtotal * province_tax_rates.gst_rate
      total_pst = subtotal * province_tax_rates.pst_rate
      total_hst = subtotal * province_tax_rates.hst_rate
      puts "GST: #{total_gst}, PST: #{total_pst}, HST: #{total_hst}" # Debug print
      total_tax = total_gst + total_pst + total_hst
      { gst: total_gst, pst: total_pst, hst: total_hst, total_price: total_tax }
    else
      { gst: 0, pst: 0, hst: 0, total_price: 0 }
    end
  end
  
  

  def total_tax_rate(province)
    calculate_taxes(1, province).values.sum
  end

  def generate_invoice(cart_items, subtotal, taxes)
    {
      customer_name: @user.email, # Using email as a placeholder for the customer name
      address: @user.address,
      province: @user.province,
      items: cart_items.map do |item|
        {
          product_name: item[:product].name,
          quantity: item[:quantity],
          unit_price: item[:product].price,
          total_price_with_tax: item_total_with_tax(item, @user.province)
        }
      end,
      subtotal: subtotal,
      taxes: taxes,
      total: subtotal + taxes[:total_price]
    }
  end
  

  def clear_cart
    session.delete(:cart)
    session.delete(:cart_quantity)
  end

  def province_options
    [
      ['Alberta', 'Alberta'],
      ['British Columbia', 'British Columbia'],
      ['Manitoba', 'Manitoba'],
      ['New Brunswick', 'New Brunswick'],
      ['Newfoundland and Labrador', 'Newfoundland and Labrador'],
      ['Northwest Territories', 'Northwest Territories'],
      ['Nova Scotia', 'Nova Scotia'],
      ['Nunavut', 'Nunavut'],
      ['Ontario', 'Ontario'],
      ['Prince Edward Island', 'Prince Edward Island'],
      ['Quebec', 'Quebec'],
      ['Saskatchewan', 'Saskatchewan'],
      ['Yukon', 'Yukon']
    ]
  end
end
