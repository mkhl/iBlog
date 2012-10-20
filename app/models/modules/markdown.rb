module Markdown

  attr_reader :_markdown_engine

  def md_to_html(markdown)
    # Some objects have more than one field to render as html.
    # For those, cache the markup engine.
    if @_markdown_engine.nil?
      options = Rails.application.config.redcarpet_options
      @_markdown_engine = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => false), options)
    end
    @_markdown_engine.render(markdown)
  end
end
