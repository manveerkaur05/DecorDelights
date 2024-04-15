class AddTaxAttributesToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :gst, :decimal
    add_column :orders, :pst, :decimal
    add_column :orders, :hst, :decimal
  end
end
