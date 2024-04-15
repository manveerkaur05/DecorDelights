# app/models/customer.rb
class Customer < ApplicationRecord
  validates :name, :address, :province, presence: true
end
