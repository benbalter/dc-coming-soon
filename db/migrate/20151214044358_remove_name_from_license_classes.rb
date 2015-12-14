class RemoveNameFromLicenseClasses < ActiveRecord::Migration
  def change
    remove_column :license_classes, :name
  end
end
