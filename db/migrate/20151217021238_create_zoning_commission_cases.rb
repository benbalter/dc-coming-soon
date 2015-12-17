class CreateZoningCommissionCases < ActiveRecord::Migration
  def change
    create_table :zoning_commission_cases do |t|

      t.timestamps null: false
    end
  end
end
