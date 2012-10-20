class AddContentHtmlToComments < ActiveRecord::Migration
  def up
    add_column :comments, :content_html, :text
    Comment.all.each do |c|
      c.update_attributes! :content_html => c.content
    end
  end
  def down
    remove_column :comments, :content_html
  end
end
