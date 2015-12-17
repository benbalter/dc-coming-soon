class DropCaseFromZoningCases < ActiveRecord::Migration
  def change
    rename_column :zoning_cases, :case_number, :number
    rename_column :zoning_cases, :case_status, :status
    rename_column :zoning_cases, :case_description, :description
  end
end
