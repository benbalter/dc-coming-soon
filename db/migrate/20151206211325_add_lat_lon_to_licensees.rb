class AddLatLonToLicensees < ActiveRecord::Migration
  def change
    add_column :licensees, :lat, :decimal, :precision => 15, :scale => 10
    add_column :licensees, :lon, :decimal, :precision => 15, :scale => 10
  end
end
