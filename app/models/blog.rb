class Blog < ActiveRecord::Base
  has_many :entries, :dependent => :destroy

  validates :name, :presence => true

  def self.by(owner)
    where(:owner => owner)
  end
end
