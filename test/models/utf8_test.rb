require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class Utf8Test < ActiveSupport::TestCase

  test 'should save blog with utf8 string' do
    # test basic utf8 string
    blog = Blog.new(name: 'sample blog です ♡⚠')
    assert blog.save
    assert_equal 'sample blog です ♡⚠', blog.name

    # test advanced utf8 multibyte strings
    blog.name = 'sample blog 💩, 🍆, 🐱'
    assert blog.save
    assert_equal 'sample blog 💩, 🍆, 🐱', blog.name
  end

  test 'should save entry with utf8 string' do
    blog = Blog.create(name: 'My Blog')
    entry = Entry.new.tap do |e|
      e.blog = blog
      e.title = 'Sample PPP'
      e.progress = 'Sample progress です ♡⚠'
    end

    assert entry.save
    assert_equal 'Sample progress です ♡⚠', entry.progress

    entry.progress = 'Sample progress 💩, 🍆, 🐱'
    assert entry.save
    assert_equal 'Sample progress 💩, 🍆, 🐱', entry.progress
  end

  test 'should save comment with utf8 string' do
    blog = Blog.create(name: 'My Blog')
    entry = Entry.new.tap do |e|
      e.blog = blog
      e.title = 'Sample PPP'
      e.progress = 'Sample progress'
      e.save
    end

    comment = Comment.new.tap do |c|
      c.content = '私のホバークラフトは鰻でいっぱいです ♡⚠'
      c.owner = entry
      c.owner_type = entry.class
    end

    assert comment.save
    assert_equal '私のホバークラフトは鰻でいっぱいです ♡⚠', comment.content

    comment.content = '💩, 🍆, 🐱'
    assert comment.save
    assert_equal '💩, 🍆, 🐱', comment.content
  end

  test 'should save weekly status with utf8 string' do
    weekly = WeeklyStatus.new(status: 'my current status です ♡⚠')
    assert weekly.save
    assert_equal 'my current status です ♡⚠', weekly.status

    weekly.status = 'my current status 💩, 🍆, 🐱'
    assert weekly.save
    assert_equal 'my current status 💩, 🍆, 🐱', weekly.status
  end
end
