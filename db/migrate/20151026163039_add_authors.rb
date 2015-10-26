class AddAuthors < ActiveRecord::Migration
  def up

    create_table :authors do |t|
      t.string :handle, null: false, index: {unique: true}
      t.string :name, null: false
      t.timestamps null: false
    end

    # Sentiniell author that will be needed temporarily:
    author = Author.new(handle: '$UNKNOWN$', name: '$UNKNOWN')
    author.save
    default_author_id = author.id
    
    # Need to replace these previous author handle cloumns:
    table_n_column = [['blogs','owner'],
                      ['comments', 'author'],
                      ['entries', 'author'],
                      ['weekly_statuses', 'author']]

    table_n_column.each do |table, column|

      add_column table.to_sym, :author_id, :integer, default: author.id, null: false, index: true
      add_foreign_key table.to_sym, :authors

      # Find any author values we have in our current table
      # and add those not yet there to the authors table.
      execute "INSERT INTO authors (handle, name, created_at, updated_at) " +
              "SELECT new_handles.handle, new_handles.handle, now(), now() from " +
              "(SELECT #{column} AS handle FROM #{table} GROUP BY handle ORDER BY handle) as new_handles " +
              "LEFT OUTER JOIN authors ON new_handles.handle = authors.handle WHERE authors.handle IS NULL;"

      # Connect our records with their respective authors.
      execute "UPDATE #{table} SET author_id = (SELECT authors.id FROM authors WHERE #{table}.#{column} = authors.handle);"

      # Remove the now-redundant column
      remove_column table.to_sym, column.to_sym

      # Remove the fake author default used during migration.
      change_column_default table.to_sym, :author_id, nil
    end

    # We no longer need the pseudo-author:
    author.destroy
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new("restore from a db dump and good luck")
  end
end
