class IndexLicenseesOnLonLat < ActiveRecord::Migration
  def change
    add_index :licensees, :lonlat, :using => :gist
  end
end
