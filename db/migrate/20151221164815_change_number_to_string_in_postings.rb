class ChangeNumberToStringInPostings < ActiveRecord::Migration
  def change
    change_column :postings, :number, :string
  end
end
