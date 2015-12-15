class AddLicenseIdToLicensees < ActiveRecord::Migration
  def change
    add_column :licensees, :license_id, :integer, unique: true
    remove_column :licensees, :license_number
  end
end
