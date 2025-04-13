class DogImage < ApplicationRecord
  belongs_to :breed
  belongs_to :sub_breed
end
