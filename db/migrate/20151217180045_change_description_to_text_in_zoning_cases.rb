class ChangeDescriptionToTextInZoningCases < ActiveRecord::Migration
  def change
    change_column :zoning_cases, :description, :text
  end
end
