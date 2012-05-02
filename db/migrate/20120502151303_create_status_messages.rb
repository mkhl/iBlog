class CreateStatusMessages < ActiveRecord::Migration

  def change
    create_table :status_messages do |t|
      t.string :author
      t.text :body

      t.timestamps
    end
  end

end
