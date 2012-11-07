class RemoveBodyFromEntries < ActiveRecord::Migration
  def up
    remove_column :entries, :body
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
