class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :key
      t.text :value
      t.references :abra_notice, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
