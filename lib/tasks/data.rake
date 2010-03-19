# -*- coding: utf-8 -*-
namespace :entries do
  namespace :testdata do
    task :create => :delete do
      print "Creating ..."
      (1..100).each do |count|             
        print "."; STDOUT.flush
        author = %w(ua ca tee me ak)[rand(4)]
        c = Entry.create({
          :plans => "Große Pläne",
          :progress => "Großartig",
          :problems => "Überhaupt keine",
          :author => author
        })
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
