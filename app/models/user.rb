# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  validates :province, presence: true
  # Address details
 # attr_accessor :address, :city, :province, :postal_code
  belongs_to :province
  has_many :orders
end

