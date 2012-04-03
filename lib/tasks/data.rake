# -*- coding: utf-8 -*-
require 'pp'
def random_author
  %w(ua ca tee me ak)[rand(4)]
end

def random_tags
  result = Set.new
  rand(3).times do
    result.add(Tag.new(:name => %w(programming java architecture ruby rails)[rand(4)]))
  end
  result
end

namespace :entries do
  namespace :convert do
    desc "Converts Textile content to HTML and caches it in the appropriate *_html columns."
    task :html => :environment do
      Entry.find_each do |entry|
        entry.regenerate_html
        entry.save!
      end
    end
  end
  namespace :testdata do
    task :create => :delete do
      print "Creating ..."
      (1..100).each do |count|
        print "."; STDOUT.flush
        c = Entry.create({
          :plans => "Große Pläne",
          :progress => "Großartig",
          :problems => "Überhaupt keine",
          :author => random_author
        })
        random_tags.each { |tag| c.tags << tag }
      end
      puts "done."
    end
    task :delete => :environment do
      print "Deleting ..."; STDOUT.flush
      Entry.delete_all
      puts "done."
    end
  end
end
