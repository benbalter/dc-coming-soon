class ChangeLonLatToStPoint < ActiveRecord::Migration
  def change
    remove_column :licensees, :lonlat
    remove_index :licensees, :lonlat if index_exists? :licensees, :lonlat

    add_column :licensees, :lonlat, :st_point, geographic: true
    add_index :licensees, :lonlat, using: :gist
  end
end
