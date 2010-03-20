class AddBlogIdToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :blog_id, :integer
  end

  def self.down
    remove_column :entries, :blog_id
  end
end
