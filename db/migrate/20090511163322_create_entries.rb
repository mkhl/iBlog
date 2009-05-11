class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.string :body, :limit => 24000
      t.string :excerpt, :limit => 1000
      t.string :author

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
