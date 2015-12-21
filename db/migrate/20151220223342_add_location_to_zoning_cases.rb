class AddLocationToZoningCases < ActiveRecord::Migration
  def change
    add_reference :zoning_cases, :location, index: true, foreign_key: true
    rename_column :zoning_cases, :address, :raw_address
  end
end
