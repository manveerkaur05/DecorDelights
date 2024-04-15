class OrderItem < ApplicationRecord
    belongs_to :order
    # Other code
    
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  end
  