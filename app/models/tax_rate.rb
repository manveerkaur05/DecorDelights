class TaxRate < ApplicationRecord
  belongs_to :province

  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.find_by_province(province_name)
    province = Province.find_by(name: province_name)
    province.tax_rates if province
  end
end
