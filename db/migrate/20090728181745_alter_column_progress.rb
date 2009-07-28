class AlterColumnProgress < ActiveRecord::Migration
  def self.up
    change_column :entries, :progress, :string, :limit => 2000
  end

  def self.down
    change_column :entries, :progress, :string, :limit => 1000
  end
end
