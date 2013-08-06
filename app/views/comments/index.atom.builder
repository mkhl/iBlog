atom_feed do |feed|
  feed.title "Kommentare (alle)"
  feed.updated @comments.last.updated_at if @comments.last
  feed.subtitle "Kommentare für alle Einträge in allen Blogs"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @comments.each do |comment|
    feed.entry(comment, :url => comment_owner_url(comment)) do |entry|
      entry.title "Kommentar von #{comment.author} zu #{comment.owner.title}"
      entry.summary :type => "html" do |html|
        html.cdata! raw(comment.content_html)
      end
      entry.content :type => "html" do |html|
        html.cdata! raw(comment.content_html)
      end
      entry.author do |author|
        author.name comment.author
      end
    end
  end
end
