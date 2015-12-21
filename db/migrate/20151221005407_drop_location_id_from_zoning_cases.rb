class DropLocationIdFromZoningCases < ActiveRecord::Migration
  def change
    remove_reference :zoning_cases, :location
  end
end
