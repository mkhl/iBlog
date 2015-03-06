class Utf8mb4Conversion < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      change_column :blogs, :name, :string, limit: 191
      change_column :blogs, :owner, :string, limit: 191
      change_column :blogs, :title, :string, limit: 191
      change_column :comments, :author, :string, limit: 191
      change_column :comments, :owner_type, :string, limit: 191
      change_column :entries, :title, :string, limit: 191
      change_column :entries, :author, :string, limit: 191
      change_column :schema_migrations, :version, :string, limit: 191
      change_column :tags, :name, :string, limit: 191
      change_column :weekly_statuses, :author, :string, limit: 191
      change_database_encoding('utf8mb4', 'utf8mb4_general_ci')
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      change_database_encoding('utf8', 'utf8_general_ci')
      change_column :blogs, :name, :string, limit: 255
      change_column :blogs, :owner, :string, limit: 255
      change_column :blogs, :title, :string, limit: 255
      change_column :comments, :author, :string, limit: 255
      change_column :comments, :owner_type, :string, limit: 255
      change_column :entries, :title, :string, limit: 255
      change_column :entries, :author, :string, limit: 255
      change_column :schema_migrations, :version, :string, limit: 255
      change_column :tags, :name, :string, limit: 255
      change_column :weekly_statuses, :author, :string, limit: 255
    end
  end

  private

  def change_database_encoding(encoding, collation)
    connection = ActiveRecord::Base.connection
    database = connection.current_database
    tables = connection.tables

    execute <<-SQL
ALTER DATABASE #{database} CHARACTER SET #{encoding} COLLATE #{collation};
SQL

    tables.each do |table|
      execute <<-SQL
ALTER TABLE #{database}.#{table} CONVERT TO CHARACTER SET #{encoding} COLLATE #{collation};
SQL
    end
  end
end
