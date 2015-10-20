# encoding: UTF-8
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
class Entry < ActiveRecord::Base
  acts_as_taggable

  include MarkdownExtension
  include AuthorExtension

  default_scope { includes(:user, :tags) }
  scope :by_date, -> { order("created_at DESC") }

  attr_accessible :title, :progress, :plans, :problems, :tag_list

  validates :title, :progress, :blog_id, :presence => true

  belongs_to :blog
  has_one :user, :primary_key => "author", :foreign_key => "handle"
  has_many :comments, :as => :owner, :dependent => :destroy

  def self.search(query)
    slots = ['title', 'progress', 'plans', 'problems']
    conditions = slots.map { |slot| "#{slot} LIKE ?" }
    params = slots.map { |slot| "%#{query}%" }
    where(conditions.join(' OR '), *params)
  end

  before_save :regenerate_html

  def author_name
    user ? user.name : author
  end

  def regenerate_html
    self.progress_html = md_to_html(progress) if progress
    self.plans_html    = md_to_html(plans) if plans
    self.problems_html = md_to_html(problems) if problems
  end
end
