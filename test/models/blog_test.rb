require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class BlogTest < ActiveSupport::TestCase
  test 'should save blog with valid attributes' do
    author = Author.for_handle 'rumpelstielzchen'
    blog = Blog.new(name: 'sample blog')
    blog.author = author
    assert blog.save, 'Saved blog with valid attributes'
  end

  test 'should not save blog without name' do
    author = Author.for_handle 'rumpelstielzchen'
    blog = Blog.new(author: author)
    refute blog.save, 'Saved blog without name'
  end
end
