class RemoveBodyFromEntries < ActiveRecord::Migration
  def up
    remove_column :entries, :body
    remove_column :entries, :excerpt
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
