class Order < ApplicationRecord
  # Serialize cart attribute to store it as JSON
  serialize :cart, JSON

  # Validation rules for required attributes
  validates :name, :address, :province, presence: true

  # Define associations
  has_many :order_items
  belongs_to :user
end
