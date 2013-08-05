atom_feed do |feed|
  feed.title "Wochenstatus"
  feed.updated @statuses.first.updated_at if @statuses.first
  feed.subtitle "yet another internal innoQ blog"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @statuses.each do |status|
    feed.entry status do |entry|
      entry.title status.title
      entry.summary :type => "html" do |html|
        html.cdata! status.status_html
      end
      entry.content :type => "html", :"xml:lang" => "en", :"xml:base" => root_url do |html|
        html.cdata! status.status_html
      end
      entry.author do |author|
        author.name status.author
        author.uri weekly_statuses_by_author_path(status.author)
      end
    end
  end
end
