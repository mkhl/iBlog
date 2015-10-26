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
class Comment < ActiveRecord::Base
  include MarkdownExtension
  include AuthorExtension

  belongs_to :author
  default_scope { includes(:author) }

  # Points to the object commented by this one.
  belongs_to :owner, :polymorphic => true

  attr_accessible :content

  validates :content, :owner_id, :owner_type, :presence => true

  before_save :regenerate_html

  def self.search(query)
    where('content LIKE ?', "%#{query}%")
  end

  def regenerate_html
    self.content_html = content ? md_to_html(content) : ""
  end
end
