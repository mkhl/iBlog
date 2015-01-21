require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class BlogTest < ActiveSupport::TestCase
  test 'should save blog with valid attributes' do
    blog = Blog.new(name: 'sample blog')
    assert blog.save, 'Saved blog with valid attributes'
  end

  test 'should not save blog without name' do
    blog = Blog.new
    refute blog.save, 'Saved blog without name'
  end
end
