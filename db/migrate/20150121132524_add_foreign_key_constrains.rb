class AddForeignKeyConstrains < ActiveRecord::Migration
  def up
    say 'remove unreferenced tags...'
    execute <<-SQL
DELETE FROM tags WHERE entry_id NOT IN (SELECT id FROM entries);
SQL

    add_foreign_key :entries, :blogs, column: 'blog_id', on_update: :cascade, on_delete: :cascade
    add_foreign_key :tags, :entries, column: 'entry_id', on_update: :cascade, on_delete: :cascade
  end

  def down
    remove_foreign_key :entries, :blogs
    remove_foreign_key :tags, :entries
  end
end
