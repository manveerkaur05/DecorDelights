# app/models/admin.rb
class Admin < ApplicationRecord
    has_secure_password
    has_many :products
  end
  