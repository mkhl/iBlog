module EntriesHelper

  def format_entry_section(section)
    content_tag :div, :class => "post-section" do
      raw section
    end
  end

  def tags(entry)
    entry.tags.map { |tag|
      content_tag :span, :class => "label tag" do
        link_to tag.name, tag_path(:tag => tag.name)
      end
    }.join(' ').html_safe
  end

end
