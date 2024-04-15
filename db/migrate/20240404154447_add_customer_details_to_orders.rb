class AddCustomerDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :customer_name, :string
    add_column :orders, :customer_email, :string
    add_column :orders, :customer_province, :string
  end
end
