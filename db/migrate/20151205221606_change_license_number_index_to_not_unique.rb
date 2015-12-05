class ChangeLicenseNumberIndexToNotUnique < ActiveRecord::Migration
  def change
    remove_index :licensees, :license_number
    add_index :licensees, :license_number
  end
end
