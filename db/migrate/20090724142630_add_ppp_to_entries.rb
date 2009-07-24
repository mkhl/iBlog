class AddPppToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :progress, :string, :limit => 1000
    add_column :entries, :plans, :string, :limit => 1000
    add_column :entries, :problems, :string, :limit => 1000
  end

  def self.down
    remove_column :entries, :progress
    remove_column :entries, :plans
    remove_column :entries, :problems
  end
end
