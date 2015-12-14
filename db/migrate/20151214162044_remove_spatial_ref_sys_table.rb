class RemoveSpatialRefSysTable < ActiveRecord::Migration
  def change
    drop_table :spatial_ref_sys
  end
end
