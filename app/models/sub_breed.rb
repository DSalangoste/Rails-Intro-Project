class SubBreed < ApplicationRecord
  belongs_to :breed
  has_many :dog_images, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :breed_id, message: "should be unique for each breed" }
  validates :slug, presence: true, uniqueness: true
  validates :breed_id, presence: true
end
