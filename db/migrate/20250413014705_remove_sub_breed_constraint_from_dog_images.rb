class RemoveSubBreedConstraintFromDogImages < ActiveRecord::Migration[8.0]
  def up
    # Remove the foreign key constraint
    remove_foreign_key :dog_images, :sub_breeds
    
    # Remove the NOT NULL constraint
    change_column :dog_images, :sub_breed_id, :integer, null: true
    
    # Add back the foreign key constraint, but allow NULL
    add_foreign_key :dog_images, :sub_breeds
  end

  def down
    change_column :dog_images, :sub_breed_id, :integer, null: false
  end
end
