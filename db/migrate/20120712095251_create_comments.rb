class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :entry
      t.string :author
      t.text :content

      t.timestamps
    end
    add_index :comments, :entry_id
  end
end
