class RemoveAncFromPostings < ActiveRecord::Migration
  def change
    remove_reference :postings, :anc
  end
end
