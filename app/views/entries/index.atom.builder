atom_feed do |feed|
  feed.title "PPP - Einträge"
  feed.updated @entries.first.updated_at if @entries.first
  feed.subtitle "yet another internal innoQ blog"
  feed.generator "i-Blogs Custom ATOM Feed Generator 1.0", :uri => root_url

  @entries.each do |blog_entry|
    feed.entry(blog_entry, :url => blog_entry_path(blog_entry.blog, blog_entry)) do |entry|
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

# <?xml version="1.0" encoding="utf-8"?>
#
# <feed xmlns="http://www.w3.org/2005/Atom">
#     <title>PPP - Einträge</title>
#     <% if @blog %><link rel="alternate" type="text/html" href="<%= blog_entries_path(@blog) %>" /><% end %>
#     <link rel="self" type="application/atom+xml" href="<%= blog_entries_path( :atom ) %>" />
#     <id>tag:internal.innoq.com/iblog,2009:/iblog//1</id>
#     <updated><%= l @entries.first.updated_at, :format => :atom if @entries.any? %></updated>
#     <subtitle>yet another internal innoQ blog</subtitle>
#
#     <generator uri="https://internal.innoq.com/iblog/">i-Blogs Custom ATOM Feed Generator 1.0</generator>
#
# <% @entries.each do |entry| %>
#     <entry>
#     <title><%= entry.title %></title>
#     <link rel="alternate" type="text/html" href="<%= blog_entry_path(entry.blog_id, entry)%>" />
#     <id>tag:internal.innoq.com/iblog,2009:/iblog//1.<%= entry.blog_id %>.<%= entry.id %></id>
#
#     <published><%= l entry.created_at, :format => :atom %></published>
#
#     <updated><%= l entry.updated_at, :format => :atom %></updated>
#
#     <summary>
#         <![CDATA[
#     <p>
#     <%= t('titles.progress') %>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.progress_html %></div>
#
#                 <% if entry.plans.present? %>
#     <p>
#                 <%= t('titles.plans') %>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.plans_html %></div>
#                 <% else %>
#                 <p>
#     <%= t('titles.no_plans') %>
#                 </p>
#                 <% end %>
#
#     <% if entry.problems.present? %>
#     <p>
#     <%= t('titles.problems') %>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.problems_html %></div>
#     <% else %>
#                 <p>
#     <%= t('titles.no_problems') %>
#                 </p>
#     <% end %>]]>
#   </summary>
#     <author>
#         <name><%= entry.author %></name>
#         <uri>https://internal.innoq.com/iblog/</uri>
#     </author>
#
#     <content type="html" xml:lang="en" xml:base="https://internal.innoq.com/iblog/">
#         <![CDATA[
#     <p>
#     <b><%= t('titles.progress') %></b>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.progress_html %></div>
#
#
#     <% if entry.plans.present? %>
#     <p>
#     <b><%= t('titles.plans') %></b>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.plans_html %></div>
#     <% else %>
#     <p>
#     <b><%= t('titles.no_plans') %></b>
#     </p>
#     <% end %>
#
#     <% if entry.problems.present? %>
#     <p>
#     <b><%= t('titles.problems') %></b>
#     </p>
#     <div style="margin-left: 10px;"><%= raw entry.problems_html %></div>
#     <% else %>
#     <p>
#     <b><%= t('titles.no_problems') %></b>
#     </p>
#     <% end %>
# ]]>
#     </content>
# </entry>
# <% end %>
# </feed>
