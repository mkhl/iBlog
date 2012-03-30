class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_nav_items, :set_user

  protected
    def set_nav_items
      @nav_side_items ||= {
        "Blogs" => [
          {
            :path    => Proc.new { blogs_by_owner_path(@user) },
            :icon    => "user",
            :title   => "Meine",
            :active? => params[:controller] == "blogs" && params[:action] == "index" && params[:owner]
          },
          {
            :path    => blogs_path,
            :icon    => "th-list",
            :title   => "Alle",
            :active? => params[:controller] == "blogs" && params[:action] == "index" && !params[:owner]
          }
        ],
        "Posts" => [
          {
            :path    => Proc.new { blog_entries_by_author_path(@user) },
            :icon    => "user",
            :title   => "Meine",
            :active? => params[:controller] == "entries" && params[:action] == "by_author" && params[:author]
          },
          {
            :path    => entries_path,
            :icon    => "fire",
            :title   => "Letzte",
            :active? => params[:controller] == "entries" && params[:action] == "full"
          }
        ]
      }
    end

    def set_user
      @user = request.headers['REMOTE_USER'] || 'guest'
    end
end
