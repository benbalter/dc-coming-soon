class AddLicenseNumberToLicensee < ActiveRecord::Migration
  def change
    add_column :licensees, :license_number, :integer
    add_index :licensees, :license_number, unique: true
  end
end
