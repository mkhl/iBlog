atom_feed do |feed|
  feed.title "PPP - Blogs"
  feed.updated @blogs.first.updated_at if @blogs.first
  feed.subtitle "yet another internal innoQ blog platform"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @blogs.each do |blog|
    feed.entry(blog, :url => blog_entries_path(blog)) do |entry|
      entry.title blog.title.presence || "-kein Name-"
      entry.summary :type => "html" do |html|
        html.cdata!("<p>Blog #{blog.title} created.</p>")
      end
      entry.content :type => "html", :"xml:lang" => "en", :"xml:base" => root_url do |html|
        html.cdata!("<p>Blog #{blog.title} created.</p>")
      end
      entry.author do |author|
        author.name blog.owner
        author.uri blog_entries_by_author_url(blog.owner)
      end
    end
  end
end
