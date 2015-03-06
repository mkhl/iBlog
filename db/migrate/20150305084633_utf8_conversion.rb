class Utf8Conversion < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      change_database_encoding('utf8', 'utf8_general_ci')
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
      change_database_encoding('latin1', 'latin1_swedish_ci')
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
