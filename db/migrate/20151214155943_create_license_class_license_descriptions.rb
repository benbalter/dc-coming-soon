class CreateLicenseClassLicenseDescriptions < ActiveRecord::Migration
  def change
    create_table :license_class_license_descriptions do |t|
      t.integer :license_class_id
      t.integer :license_description_id

      t.timestamps null: false
    end
  end
end
