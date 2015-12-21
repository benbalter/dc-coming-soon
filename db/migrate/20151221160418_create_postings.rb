class CreatePostings < ActiveRecord::Migration
  def change
    create_table :postings do |t|
      t.string :type
      t.string :slug
      t.date :posting_date
      t.date :hearing_date
      t.integer :pdf_page
      t.references :abra_bulletin, index: true, foreign_key: true
      t.text :details
      t.text :body
      t.references :licensee, index: true, foreign_key: true
      t.string :applicant
      t.string :raw_address
      t.integer :number
      t.string :status

      t.timestamps null: false
    end
    add_index :postings, :type
    add_index :postings, :slug
    add_index :postings, :number
    add_index :postings, :status

    drop_table :abra_notices
    drop_table :zoning_cases
  end
end
