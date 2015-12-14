class IndexLicenseesOnLicenseNumber < ActiveRecord::Migration
  def change
    remove_index :licensees, :license_number
    add_index :licensees, :license_number, :unique => true
  end
end
