class MakeSubBreedIdNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null :dog_images, :sub_breed_id, true
  end
end
