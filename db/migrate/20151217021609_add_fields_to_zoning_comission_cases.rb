class AddFieldsToZoningComissionCases < ActiveRecord::Migration
  def change
    create_table :zoning_comission_cases
    add_column :zoning_comission_cases, :type, :string
    add_column :zoning_comission_cases, :applicant, :string
    add_column :zoning_comission_cases, :address, :string
    add_column :zoning_comission_cases, :case_number, :string
    add_column :zoning_comission_cases, :case_status, :string
    add_column :zoning_comission_cases, :relief_type, :string
    add_reference :zoning_comission_cases, :anc, index: true, foreign_key: true
    add_column :zoning_comission_cases, :case_description, :string
    drop_table :zc_cases
  end
end
