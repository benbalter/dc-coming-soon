class RenameLicenseClassIdToLicenseClassLicenseDescriptionIdInLicensees < ActiveRecord::Migration
  def change
    rename_column :licensees, :license_class_id, :license_class_license_description_id
  end
end
