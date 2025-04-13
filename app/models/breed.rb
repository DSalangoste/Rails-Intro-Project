class Breed < ApplicationRecord
  has_many :sub_breeds, dependent: :destroy
  has_many :dog_images, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :group, presence: true
  validates :origin, presence: true
  validates :temperament, presence: true
end
