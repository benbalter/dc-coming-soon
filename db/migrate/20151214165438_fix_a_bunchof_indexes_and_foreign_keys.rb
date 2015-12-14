class FixABunchofIndexesAndForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :license_class_license_descriptions, :license_classes
    add_foreign_key :license_class_license_descriptions, :license_descriptions

    add_index :license_class_license_descriptions, :license_class_id
    add_index :license_class_license_descriptions, :license_description_id, name: 'index_license_class_license_descriptions_on_description_id'

    remove_index :license_classes, :letter
    add_index :license_classes, :letter, unique: true

    add_index :licensees, :status
    add_index :licensees, :lat
    add_index :licensees, :lon
  end
end
