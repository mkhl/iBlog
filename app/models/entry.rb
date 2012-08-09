class Entry < ActiveRecord::Base
  validates_presence_of :progress

  belongs_to :blog
  has_many :tags
  has_many :comments, :dependent => :destroy

  before_save do |entry|
    regenerate_html
  end

  def owned_by?(user)
    author == user
  end

  def tags_as_string
    tags.map { |t| t.name }.join(' ')
  end

  def tags_as_string=(tags_as_string)
    tags.destroy_all
    self.tags = tags_as_string.split(' ').map { |t| Tag.new(:name => t) }
  end

  def regenerate_html
    options = Rails.application.config.redcarpet_options
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => false), options)

    self.progress_html = markdown.render(progress)
    self.plans_html    = markdown.render(plans)
    self.problems_html = markdown.render(problems)
  end
end
