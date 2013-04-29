Copyright 2013 innoQ Deutschland GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
# encoding: UTF-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user, :set_nav_items

  protected
    def set_nav_items
      return @nav_items if @nav_items
      @nav_side_items = ActiveSupport::OrderedHash.new
      @nav_side_items["Einträge"] = [
        {
          :path    => Proc.new { blog_entries_by_author_path(@user) },
          :icon    => "user",
          :title   => "Meine",
          :active? => params[:controller] == "entries" && params[:action] == "user_home" && params[:author]
        },
        {
          :path    => all_entries_path,
          :icon    => "fire",
          :title   => "Letzte",
          :active? => params[:controller] == "entries" && params[:action] == "full"
        }
      ]
      @nav_side_items["Kommentare"] = [
        {
          :path    => Proc.new { comments_path(:author => @user) },
          :icon    => "user",
          :title   => "Meine",
          :active? => params[:controller] == "comments" && params[:action] == "index" && params[:author] == @user
        },
        {
          :path    => comments_path,
          :icon    => "fire",
          :title   => "Letzte",
          :active? => params[:controller] == "comments" && params[:action] == "index" && !params[:author]
        }
      ]
      @nav_side_items["Blogs"] = [
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
      ]
      @nav_side_items["Feeds"] = [
        {
          :path    => blogs_path(:format => :atom),
          :icon    => "fire",
          :title   => "Blogs",
          :active? => false
        },
        {
          :path    => all_entries_path(:format => :atom),
          :icon    => "fire",
          :title   => "Einträge",
          :active? => false
        },
        {
          :path    => comments_path(:format => :atom),
          :icon    => "fire",
          :title   => "Kommentare",
          :active? => false
        }
      ]
      @nav_side_items
    end

    def set_user
      @user = request.headers['REMOTE_USER'] || 'guest'
    end
end
