class AddAddressFieldsToLicensees < ActiveRecord::Migration
  def change
    add_column :licensees, :street_number, :int
    add_column :licensees, :street_name, :string
    add_column :licensees, :type, :string
    add_column :licensees, :quad, :string
  end
end
