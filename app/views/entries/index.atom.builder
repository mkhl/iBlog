atom_feed do |feed|
  feed.title "PPPs"
  feed.updated @entries.first.updated_at if @entries.first
  feed.subtitle "yet another internal innoQ blog"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @entries.each do |blog_entry|
    feed.entry(blog_entry, :url => blog_entry_url(blog_entry.blog, blog_entry)) do |entry|
      entry.title blog_entry.title
      entry.summary :type => "html" do |html|
        html.cdata! render("entry_cdata.html", :entry => blog_entry)
      end
      entry.content :type => "html", :"xml:lang" => "en", :"xml:base" => root_url do |html|
        html.cdata! render("entry_cdata.html", :entry => blog_entry)
      end
      entry.author do |author|
        author.name blog_entry.author
        author.uri blog_entries_by_author_url(blog_entry.author)
      end
    end
  end
end
