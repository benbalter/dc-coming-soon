class AddLocationToPostings < ActiveRecord::Migration
  def change
    add_reference :postings, :location, index: true, foreign_key: true
  end
end
