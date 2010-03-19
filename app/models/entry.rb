class Entry < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 25
  
  validates_presence_of :plans
  validates_length_of :plans, :within => 3..1000
  
  validates_presence_of :progress
  validates_length_of :progress, :within => 3..2000
    
  validates_length_of :problems, :maximum => 1000, :if => proc { |obj| obj.problems }
end
