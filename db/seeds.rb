# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'httparty'

puts "Cleaning the database..."
DogImage.destroy_all
SubBreed.destroy_all
Breed.destroy_all

puts "Fetching data from The Dog API..."
dog_api_url = "https://api.thedogapi.com/v1/breeds"

# Use environment variable for API key
response = HTTParty.get(dog_api_url, headers: { 'x-api-key' => ENV['DOG_API_KEY'] })
breeds_data = JSON.parse(response.body)

breeds_data.each do |breed_data|
  begin
    breed = Breed.create!(
      name: breed_data['name'],
      slug: breed_data['name'].downcase.gsub(' ', '-'),
      group: breed_data['breed_group'] || 'Mixed',
      origin: breed_data['country_of_origin'] || 'Not Specified',
      temperament: breed_data['temperament'] || 'Not Specified'
    )
    puts "Created breed: #{breed.name}"
  rescue => e
    puts "Error creating breed #{breed_data['name']}: #{e.message}"
  end
end

puts "Fetching data from Dog CEO API..."
dog_ceo_url = "https://dog.ceo/api/breeds/list/all"
response = HTTParty.get(dog_ceo_url)
all_breeds = JSON.parse(response.body)['message']

all_breeds.each do |breed_name, sub_breeds|
  breed = Breed.find_by(name: breed_name.capitalize)
  next unless breed

  # Create sub-breeds if they exist
  sub_breeds.each do |sub_breed_name|
    sub_breed = SubBreed.create!(
      name: sub_breed_name,
      slug: "#{breed_name}-#{sub_breed_name}",
      breed: breed
    )
    puts "Created sub-breed: #{sub_breed.name} for #{breed.name}"
  end

  # Increased from 5 to 10 images per breed to ensure we meet the 200 row requirement
  images_url = "https://dog.ceo/api/breed/#{breed_name}/images/random/10"
  images_response = HTTParty.get(images_url)
  images = JSON.parse(images_response.body)['message']
  
  images.each do |image_url|
    DogImage.create!(
      image_url: image_url,
      breed: breed,
      sub_breed: nil
    )
    puts "Created image for #{breed.name}"
  end
end

# Print final counts
puts "\nFinal row counts:"
puts "Breeds: #{Breed.count}"
puts "SubBreeds: #{SubBreed.count}"
puts "DogImages: #{DogImage.count}"
puts "Total rows: #{Breed.count + SubBreed.count + DogImage.count}"
