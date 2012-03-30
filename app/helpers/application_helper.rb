# encoding: UTF-8

module ApplicationHelper

  def notification(type, message)
    content_tag :div, :class => "alert alert-#{type}" do
      content = ActiveSupport::SafeBuffer.new
      content << link_to("&times;".html_safe, "", :class => "close", :"data-dismiss" => "alert")
      content << message
      content
    end
  end

  def glyph(name, color = nil)
    color_suffix = color ? " icon-white" : ""

    @glyphs = {
      :edit   => "<i class='icon-edit#{color_suffix}'></i> Bearbeiten".html_safe,
      :delete => "<i class='icon-trash#{color_suffix}'></i> Löschen".html_safe,
      :tags   => "<i class='icon-tag#{color_suffix}'></i>".html_safe
    }
    @glyphs[name.to_sym]
  end

  def nav_side_items(items)
    html = ActiveSupport::SafeBuffer.new

    items.each do |key, values|
      html << content_tag(:li, key, :class => 'nav-header')
      values.each do |value|
        css_class = value[:active?] ? "active" : ""
        path = value[:path].respond_to?(:call) ? value[:path].call : value[:path]
        title = if value[:icon]
          content_tag(:i, nil, :class => "icon-#{value[:icon]}") + value[:title]
        else
          value[:title]
        end

        html << content_tag(:li, link_to(title.html_safe, path), :class => css_class)
      end
    end

    html
  end

end
