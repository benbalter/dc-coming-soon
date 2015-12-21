class RemoveLatAndLonFromZoningComissionCases < ActiveRecord::Migration
  def change
    remove_column :zoning_cases, :lat
    remove_column :zoning_cases, :lonw
  end
end
