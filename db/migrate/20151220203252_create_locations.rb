class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :street_number
      t.string :street_name
      t.string :street_type
      t.string :quad
      t.decimal :lat
      t.decimal :lng
      t.string :slug
      t.references :anc, index: true, foreign_key: true
    end
    add_index :locations, :slug, unique: true
  end
end
