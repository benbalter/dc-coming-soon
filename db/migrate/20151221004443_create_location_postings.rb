class CreateLocationPostings < ActiveRecord::Migration
  def change
    create_table :location_postings do |t|
      t.references :location, index: true, foreign_key: true
      t.references :posting, polymorphic: true, index: true
    end
  end
end
