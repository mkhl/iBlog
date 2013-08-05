class MakeCommentsPolymorphic < ActiveRecord::Migration
  def change
    rename_column :comments, :entry_id, :owner_id
    add_column :comments, :owner_type, :string
    add_index :comments, [:owner_id, :owner_type]

    connection.execute "UPDATE comments SET owner_type = 'Entry'"
  end
end
