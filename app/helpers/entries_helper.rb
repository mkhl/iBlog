module EntriesHelper
  def tags(entry)
    entry.tags.map { |tag|
      link_to(tag.name, tag_path(:tag => tag.name))
    }.join(' ').html_safe
  end
end
