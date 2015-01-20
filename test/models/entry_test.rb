require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class EntryTest < ActiveSupport::TestCase

  setup do
    @blog = Blog.create(name: 'sample blog')
  end

  test 'should save entry with valid attributes' do
    entry = Entry.new(title: 'Test-PPP', progress: 'My progress...')
    entry.blog = @blog
    assert entry.save
  end

  test 'should not save entry with invalid attributes' do
    entry = Entry.new
    refute entry.save, 'Saved entry with invalid attributes'
  end

  test 'markdown rendering' do
    entry = Entry.new
    assert entry.respond_to?('md_to_html'), 'should respond to md_to_html()'
    assert entry.md_to_html('# Headline').include? '<h1>Headline</h1>'
  end
end
