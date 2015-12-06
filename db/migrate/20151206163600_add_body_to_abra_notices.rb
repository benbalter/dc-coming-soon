class AddBodyToAbraNotices < ActiveRecord::Migration
  def change
    add_column :abra_notices, :body, :text
  end
end
