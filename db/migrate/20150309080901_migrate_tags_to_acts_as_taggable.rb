class MigrateTagsToActsAsTaggable < ActiveRecord::Migration
  def up
    legacy_tags = ActiveRecord::Base.connection.exec_query('SELECT LOWER(name) as tag_name, entry_id as tag_entry_id FROM tags_legacy;')

    legacy_tags.each do |row|
      # remove possible comma in tag name
      tag_name = row['tag_name'].gsub(',', '')
      tag_entry_id = row['tag_entry_id']

      tag_id = create_or_find_tag_id(tag_name)

      # create tagging
      execute <<-SQL
INSERT INTO taggings (tag_id, taggable_id, taggable_type, context, created_at)
VALUES (#{tag_id}, #{tag_entry_id}, 'Entry', 'tags', NOW());
SQL

    end
  end

  def down
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE tags;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE taggings;")
  end

  private

  def create_or_find_tag_id(tag_name)
    tag = ActiveRecord::Base.connection.exec_query("SELECT id, name, taggings_count FROM tags WHERE name = '#{tag_name}';")

    if tag.rows.any?
      # use existing tag
      result = tag.to_hash.first['id']

      # update tag counter
      new_taggings_count = tag.to_hash.first['taggings_count'] + 1
      ActiveRecord::Base.connection.execute("UPDATE tags SET taggings_count = '#{new_taggings_count}' WHERE name = '#{tag_name}';")
    else
      # create new tag
      ActiveRecord::Base.connection.execute("INSERT INTO tags (name, taggings_count) VALUES ('#{tag_name}', 1);")
      new_tag = ActiveRecord::Base.connection.exec_query("SELECT id, name, taggings_count FROM tags WHERE name = '#{tag_name}';")
      result = new_tag.to_hash.first['id']
    end

    result
  end


end
