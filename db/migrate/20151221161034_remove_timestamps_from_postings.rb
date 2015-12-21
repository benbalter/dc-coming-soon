class RemoveTimestampsFromPostings < ActiveRecord::Migration
  def change
    remove_column :postings, :created_at
    remove_column :postings, :updated_at
  end
end
