class AddPdfPageToAbraNotices < ActiveRecord::Migration
  def change
    add_column :abra_notices, :pdf_page, :integer
  end
end
