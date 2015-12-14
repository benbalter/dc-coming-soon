class RemoveTimestampsFromLicenseClassLicenseDescription < ActiveRecord::Migration
  def change
    remove_column :license_class_license_descriptions, :created_at
    remove_column :license_class_license_descriptions, :updated_at
  end
end
