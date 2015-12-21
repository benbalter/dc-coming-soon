class DropAddressFromLicensee < ActiveRecord::Migration
  def change
    remove_column :licensees, :lat
    remove_column :licensees, :lon
    remove_column :licensees, :street_number
    remove_column :licensees, :street_type
    remove_column :licensees, :street_name
    remove_column :licensees, :quad
    add_reference :licensees, :location, index: true, foreign_key: true
  end
end
