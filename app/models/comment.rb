require "modules/markdown"
require "modules/authored"
class Comment < ActiveRecord::Base
  include Markdown
  include Authored

  belongs_to :entry

  before_save :regenerate_html

  def regenerate_html
    self.content_html = md_to_html(content)
  end
end
