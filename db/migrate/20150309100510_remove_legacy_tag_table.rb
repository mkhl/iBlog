class RemoveLegacyTagTable < ActiveRecord::Migration
  def up
    execute <<-SQL
DROP TABLE tags_legacy;
SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
