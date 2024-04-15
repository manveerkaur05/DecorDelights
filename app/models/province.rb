class Province < ApplicationRecord
    has_many :tax_rates
    validates :name, presence: true
  end
  