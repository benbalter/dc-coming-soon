class CreateLicenseClasses < ActiveRecord::Migration
  def change
    create_table :license_classes do |t|
      t.string :name
      t.string :letter
    end
    add_index :license_classes, :name, unique: true
    add_index :license_classes, :letter, unique: true
  end
end
