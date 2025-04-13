class DogImage < ApplicationRecord
  belongs_to :breed
  belongs_to :sub_breed, optional: true
  
  validates :image_url, presence: true, uniqueness: true
  validates :breed_id, presence: true
end
