class AddForeignKeyConstrains < ActiveRecord::Migration
  def change
    add_foreign_key :entries, :blogs, column: 'blog_id', on_update: :cascade, on_delete: :cascade
    add_foreign_key :tags, :entries, column: 'entry_id', on_update: :cascade, on_delete: :cascade
  end
end
