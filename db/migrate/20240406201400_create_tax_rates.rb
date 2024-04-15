class CreateTaxRates < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_rates do |t|
      t.string :province
      t.decimal :gst_rate
      t.decimal :pst_rate
      t.decimal :hst_rate

      t.timestamps
    end
  end
end
