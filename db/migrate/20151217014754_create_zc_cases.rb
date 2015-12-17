class CreateZcCases < ActiveRecord::Migration
  def change
    create_table :zc_cases do |t|

      t.timestamps null: false
    end
  end
end
