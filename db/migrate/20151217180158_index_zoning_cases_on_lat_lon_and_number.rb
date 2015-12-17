class IndexZoningCasesOnLatLonAndNumber < ActiveRecord::Migration
  def change
    add_index :zoning_cases, :number, unique: true
    add_index :zoning_cases, :lat
    add_index :zoning_cases, :lon
  end
end
