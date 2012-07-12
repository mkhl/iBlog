class Comment < ActiveRecord::Base
  belongs_to :entry

  before_save :regenerate_html

  def regenerate_html
    options = Rails.application.config.redcarpet_options
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), options)

    self.content = markdown.render(content)
  end
end
