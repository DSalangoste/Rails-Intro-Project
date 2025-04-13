class CreateSubBreeds < ActiveRecord::Migration[8.0]
  def change
    create_table :sub_breeds do |t|
      t.string :name
      t.string :slug
      t.references :breed, null: false, foreign_key: true

      t.timestamps
    end
  end
end
