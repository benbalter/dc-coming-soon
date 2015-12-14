class CreateLicenseClassDescriptions < ActiveRecord::Migration
  def change
    create_table :license_class_descriptions do |t|
      t.string :description
    end
    add_index :license_class_descriptions, :description, unique: true
  end
end
