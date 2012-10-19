atom_feed do |feed|
  feed.title "PPP - Kommentare (alle)"
  feed.updated @comments.last.updated_at if @comments.last
  feed.subtitle "Kommentare für alle Einträge in allen Blogs"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @comments.each do |comment|
    feed.entry(comment, :url => blog_entry_url(comment.entry.blog, comment.entry, :anchor => "comment-#{comment.id}")) do |entry|
      entry.title "Kommentar von #{comment.author} zu #{comment.entry.title}"
      entry.summary :type => "html" do |html|
        html.cdata! raw(comment.content)
      end
      entry.content :type => "html" do |html|
        html.cdata! raw(comment.content)
      end
      entry.author do |author|
        author.name comment.author
      end
    end
  end
end
