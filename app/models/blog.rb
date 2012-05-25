class Blog < ActiveRecord::Base
  has_many :entries, :dependent => :destroy

  validates :name, :presence => true
end
