class SubBreed < ApplicationRecord
  belongs_to :breed
  has_many :dog_images, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :breed_id }
  validates :slug, presence: true, uniqueness: true
  validates :breed_id, presence: true
end
