class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.string :body
      t.string :excerpt
      t.string :author

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
