require "modules/markdown"
class Comment < ActiveRecord::Base
  include Markdown

  belongs_to :entry

  before_save :regenerate_html

  def regenerate_html
    self.content_html = md_to_html(content)
  end
end
