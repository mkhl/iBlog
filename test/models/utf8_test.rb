# coding: utf-8
require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class Utf8Test < ActiveSupport::TestCase

  test 'should save blog with utf8 string' do
    # test basic utf8 string
    blog = Blog.new(name: 'sample blog です ♡⚠')
    blog.author = Author.for_handle 'äöü'
    assert blog.save
    assert_equal 'sample blog です ♡⚠', blog.name

    # test advanced utf8 multibyte strings
    blog.name = 'sample blog 💩, 🍆, 🐱'
    assert blog.save
    assert_equal 'sample blog 💩, 🍆, 🐱', blog.name

    blog_again = Blog.find blog.id
    assert_equal 'äöü', blog_again.author.handle
    assert_equal 'sample blog 💩, 🍆, 🐱', blog_again.name
  end

  test 'should save author and entry with utf8 strings' do

    author = Author.for_handle('äöüß')
    author.name = 'ÄÖÜäöüß'
    assert author.save
    
    blog = Blog.new(name: 'My Blog')
    blog.author = author
    blog.save

    entry = Entry.new.tap do |e|
      e.blog = blog
      e.title = 'Sample PPP'
      e.author = author
      e.progress = 'Sample progress です ♡⚠'
    end

    assert entry.save

    entry_again = Entry.find entry.id
    assert_equal 'Sample progress です ♡⚠', entry_again.progress
    assert_equal 'ÄÖÜäöüß', entry_again.author.name
    assert_equal 'äöüß', entry_again.author.handle

    entry.progress = 'Sample progress 💩, 🍆, 🐱'
    assert entry.save
    entry_once_again = Entry.find entry.id
    assert_equal 'Sample progress 💩, 🍆, 🐱', entry_once_again.progress
    assert_equal 'äöüß', entry_once_again.author.handle
    assert_equal 'ÄÖÜäöüß', entry_once_again.author.name
  end

  test 'should save comment with utf8 string' do
    blog = Blog.new(name: 'My Blog')
    blog.author = Author.for_handle 'hasablog'
    blog.save
    entry = Entry.new.tap do |e|
      e.blog = blog
      e.title = 'Sample PPP'
      e.progress = 'Sample progress'
      e.author = blog.author
      e.save
    end

    comment = Comment.new.tap do |c|
      c.content = '私のホバークラフトは鰻でいっぱいです ♡⚠'
      c.owner = entry
      c.owner_type = entry.class
      c.author = Author.for_handle '鰻'
    end

    assert comment.save
    assert_equal '私のホバークラフトは鰻でいっぱいです ♡⚠', comment.content

    comment.content = '💩, 🍆, 🐱'
    assert comment.save
    assert_equal '💩, 🍆, 🐱', comment.content
  end

  test 'should save weekly status with utf8 string' do
    weekly = WeeklyStatus.new(status: 'my current status です ♡⚠')
    weekly.author = Author.for_handle '☺'
    assert weekly.save
    assert_equal 'my current status です ♡⚠', weekly.status

    weekly.status = 'my current status 💩, 🍆, 🐱'
    assert weekly.save
    assert_equal 'my current status 💩, 🍆, 🐱', weekly.status

    weekly_again = WeeklyStatus.find weekly.id
    assert_equal 'my current status 💩, 🍆, 🐱', weekly_again.status
    assert_equal '☺', weekly_again.author.handle
  end
end
