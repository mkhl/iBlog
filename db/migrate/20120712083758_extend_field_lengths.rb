class ExtendFieldLengths < ActiveRecord::Migration
  def up
    change_column :entries, :progress, :text
    change_column :entries, :plans, :text
    change_column :entries, :problems, :text
    change_column :entries, :progress_html, :text
    change_column :entries, :plans_html, :text
    change_column :entries, :problems_html, :text
  end

  def down
  end
end
