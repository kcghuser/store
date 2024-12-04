# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'faker'

# Find or create Categories
puts "Ensuring categories exist..."
categories = [
  { name: 'Electronics', description: Faker::Lorem.sentence(word_count: 10) },
  { name: 'Home & Garden', description: Faker::Lorem.sentence(word_count: 10) },
  { name: 'Fashion', description: Faker::Lorem.sentence(word_count: 10) },
  { name: 'Sports & Outdoors', description: Faker::Lorem.sentence(word_count: 10) }
].map do |category_data|
  Category.find_or_create_by!(name: category_data[:name]) do |category|
    category.description = category_data[:description]
  end
end

# Seed Products
puts "Adding new products..."
existing_product_count = Product.count
(100 - existing_product_count).times do
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price: Faker::Commerce.price(range: 10..500),
    category: categories.sample, # Randomly assign a category
    active: [true, false].sample # Randomly set active status
  )
end

puts "Seeding complete! #{Product.count} products now exist."