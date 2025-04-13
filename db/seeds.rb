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

# Fix the API key format in headers
response = HTTParty.get(dog_api_url, headers: { 'x-api-key' => 'live_J41fbrgVGKc0wBUCd5eeAkFWv7XEtmYRCpuS9HnFk1DPjVE21e9nwzARp0STU8Dx' })
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

  # Fetch and save some images for each breed
  images_url = "https://dog.ceo/api/breed/#{breed_name}/images/random/5"
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

puts "Seeding completed!"
