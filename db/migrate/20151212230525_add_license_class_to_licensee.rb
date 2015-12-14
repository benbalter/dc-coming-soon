class AddLicenseClassToLicensee < ActiveRecord::Migration
  def change
    add_reference :licensees, :license_class, index: true, foreign_key: true
  end
end
