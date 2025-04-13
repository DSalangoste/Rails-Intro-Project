class CreateBreeds < ActiveRecord::Migration[8.0]
  def change
    create_table :breeds do |t|
      t.string :name
      t.string :slug
      t.string :group
      t.string :origin
      t.text :temperament

      t.timestamps
    end
  end
end
