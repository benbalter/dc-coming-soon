class DropZoningComissionCases < ActiveRecord::Migration
  def change
    drop_table :zoning_comission_cases
    create_table :zoning_cases
    add_column :zoning_cases, :type, :string
    add_column :zoning_cases, :applicant, :string
    add_column :zoning_cases, :address, :string
    add_column :zoning_cases, :case_number, :string
    add_column :zoning_cases, :case_status, :string
    add_column :zoning_cases, :relief_type, :string
    add_reference :zoning_cases, :anc, index: true, foreign_key: true
    add_column :zoning_cases, :case_description, :string
    add_column :zoning_cases, :lat, :decimal
    add_column :zoning_cases, :lon, :decimal
  end
end
