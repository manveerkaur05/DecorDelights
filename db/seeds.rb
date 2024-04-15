# db/seeds.rb
Admin.create(username: 'manveerk', password: 'adminpassword', password_confirmation: 'adminpassword')
# db/seeds.rb

require 'faker'

# Create categories
categories = %w(Furniture Decorative\ Accents Lighting Textiles)

categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

# Seed products
categories.each do |category_name|
  category = Category.find_by(name: category_name)
  25.times do
    Product.create(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 2),
      price: Faker::Commerce.price(range: 50..500, as_string: true),
      category: category # Use the association directly
    )
  end
end

# Define provinces array with tax rates
provinces = [
  { name: 'Alberta', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { name: 'British Columbia', gst_rate: 0.05, pst_rate: 0.07, hst_rate: nil },
  { name: 'Manitoba', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0 },
  { name: 'New Brunswick', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { name: 'Newfoundland and Labrador', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { name: 'Northwest Territories', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { name: 'Nova Scotia', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { name: 'Nunavut', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { name: 'Ontario', gst_rate: 0, pst_rate: 0, hst_rate: 0.13 },
  { name: 'Prince Edward Island', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { name: 'Quebec', gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0 },
  { name: 'Saskatchewan', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0 },
  { name: 'Yukon', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 }
]



# Create new tax rates for all provinces
provinces.each do |province|
  province_instance = Province.find_or_create_by(name: province[:name])
  TaxRate.create(
    province: province_instance,
    gst_rate: province[:gst_rate],
    pst_rate: province[:pst_rate],
    hst_rate: province[:hst_rate]
  )
end

puts "Seed script completed!"
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?