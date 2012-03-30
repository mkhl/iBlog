class Entry < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25

  validates_length_of :plans, :maximum => 1000

  validates_presence_of :progress
  validates_length_of :progress, :within => 3..2000

  validates_length_of :problems, :maximum => 1000, :if => proc { |obj| obj.problems }

  belongs_to :blog
  has_many :tags

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
end
