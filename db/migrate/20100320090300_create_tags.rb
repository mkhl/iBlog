class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags, :id => false do |t|
      t.string :name
      t.integer :entry_id
    end
  end

  def self.down
    drop_table :tags
  end
end
