module EntriesHelper
  def tags(entry)
    result = []
    entry.tags.each do |t|
      result << link_to(t.name, tag_path(:tag => t.name))
    end
    result.join(' ')
  end
end
