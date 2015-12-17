class AddHearingDateToZoningCases < ActiveRecord::Migration
  def change
    add_column :zoning_cases, :hearing_date, :date
    add_index :zoning_cases, :hearing_date
  end
end
