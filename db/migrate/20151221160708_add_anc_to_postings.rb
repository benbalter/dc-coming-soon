class AddAncToPostings < ActiveRecord::Migration
  def change
    add_reference :postings, :anc, index: true, foreign_key: true
  end
end
