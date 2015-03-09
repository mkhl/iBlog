class RenameTagsTable < ActiveRecord::Migration
  def up
    rename_table :tags, :tags_legacy
  end

  def down
    rename_table :lecagy_tags, :tags
  end
end
