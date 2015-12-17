class AddFieldsToZcCases < ActiveRecord::Migration
  def change
    add_column :zc_cases, :type, :string
    add_column :zc_cases, :applicant, :string
    add_column :zc_cases, :address, :string
    add_column :zc_cases, :case_number, :string
    add_column :zc_cases, :case_status, :string
    add_column :zc_cases, :relief_type, :string
    add_reference :zc_cases, :anc, index: true, foreign_key: true
    add_column :zc_cases, :case_description, :string
  end
end
