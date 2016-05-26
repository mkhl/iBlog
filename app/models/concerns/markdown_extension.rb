# Copyright 2014 innoQ Deutschland GmbH

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module MarkdownExtension
  extend ActiveSupport::Concern

  included do
    attr_reader :_markdown_engine
  end

  def md_to_html(markdown)
    # Some objects have more than one field to render as html.
    # For those, cache the markup engine.
    if @_markdown_engine.nil?
      options = { :autolink => true, :fenced_code_blocks => true }
      @_markdown_engine = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => false), options)
    end
    @_markdown_engine.render(markdown)
  end
end
