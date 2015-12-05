class ChangeLicenseNumberFromIntegerToString < ActiveRecord::Migration
  def change
    remove_column :licensees, :license_number
    add_column :licensees, :license_number, :string
    add_index :licensees, :license_number, unique: true
  end
end
