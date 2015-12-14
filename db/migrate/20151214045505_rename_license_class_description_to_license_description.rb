class RenameLicenseClassDescriptionToLicenseDescription < ActiveRecord::Migration
  def change
    rename_table :license_class_descriptions, :license_descriptions
  end
end
