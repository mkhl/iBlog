class AddHtmlFieldsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :progress_html, :string, :limit => 2000
    add_column :entries, :plans_html, :string, :limit => 1000
    add_column :entries, :problems_html, :string, :limit => 1000
  end
end
